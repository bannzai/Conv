//
//  Algorithm.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

enum Operation<I> {
    case insert(I)
    case delete(I)
    case move(I, I)
    case update(I)
}

enum Occurence {
    case unique(Int)
    case many(IndicesReference)
    
    static func start(_ index: Int) -> Occurence {
        return .unique(index)
    }
    
}

struct DifferenciableIndexPath: Differenciable {
    let uuid: String
    
    let section: Section
    let item: ItemDelegate
    
    let sectionIndex: Int
    let itemIndex: Int
    
    var differenceIdentifier: DifferenceIdentifier {
        return section.differenceIdentifier + "000000000000000000" + item.differenceIdentifier
    }
    
    var indexPath: IndexPath {
        return IndexPath(item: itemIndex, section: sectionIndex)
    }
}

extension DifferenciableIndexPath: CustomStringConvertible {
    var description: String {
        return "section: \(sectionIndex), item: \(itemIndex)"
    }
}

struct OperationSet {
    var sectionInsert: [Int] = []
    var sectionUpdate: [Int] = []
    var sectionDelete: [Int] = []
    var sectionMove: [(source: Int, target: Int)] = []
    
    var itemInsert: [DifferenciableIndexPath] = []
    var itemUpdate: [DifferenciableIndexPath] = []
    var itemDelete: [DifferenciableIndexPath] = []
    var itemMove: [(source: DifferenciableIndexPath, target: DifferenciableIndexPath)] = []
    
    init() {
        
    }
}

struct Diff {
    func diff(
        from oldIndexPaths: [DifferenciableIndexPath],
        to newIndexPaths: [DifferenciableIndexPath],
        oldSectionReferences: [Int?],
        newSectionReferences: [Int?]
        ) {
        var table: [DifferenceIdentifier: Occurence] = [:]
        
        var oldReferences: [DifferenciableIndexPath?] = Array(repeating: nil, count: oldIndexPaths.count)
        var newReferences: [DifferenciableIndexPath?] = Array(repeating: nil, count: newIndexPaths.count)

        setupTable: do {
            for (offset, oldIndexPath) in oldIndexPaths.enumerated() {
                let key = oldIndexPath.differenceIdentifier
                switch table[key] {
                case nil:
                    table[key] = Occurence.start(offset)
                case .unique(let oldIndex)?:
                    let reference = IndicesReference([oldIndex, offset])
                    table[key] = .many(reference)
                case .many(let indexies)?:
                    table[key] = .many(indexies.push(offset))
                }
            }
        }
        
        recordRelation: do {
            for (offset, newIndexPath) in newIndexPaths.enumerated() {
                switch table[newIndexPath.differenceIdentifier] {
                case nil:
                    // The indexPath means to insert after step
                    break
                case .unique(let oldIndex)?:
                    if oldReferences[oldIndex] == nil {
                        newReferences[offset] = oldIndexPaths[oldIndex]
                        oldReferences[oldIndex] = newIndexPaths[offset]
                    }
                case .many(let indexies)?:
                    if let oldIndex = indexies.pop() {
                        newReferences[offset] = oldIndexPaths[oldIndex]
                        oldReferences[oldIndex] = newIndexPaths[offset]
                    }
                }
            }
        }

        let oldItemsEachSection = oldIndexPaths.reduce(into: [[Differenciable]]()) { (result, indexPath: DifferenciableIndexPath) in
            if result.count <= indexPath.sectionIndex {
                result.append([])
            }
            
            result[indexPath.sectionIndex].append(indexPath.item)
        }
        
        let newItemsEachSection = newIndexPaths.reduce(into: [[Differenciable]]()) { (result, indexPath: DifferenciableIndexPath) in
            if result.count <= indexPath.sectionIndex {
                result.append([])
            }
            
            result[indexPath.sectionIndex].append(indexPath.item)
        }

        var steps: [Operation<DifferenciableIndexPath>] = []
        
        var deletedOffsets: [Int] = Array(repeating: 0, count: oldIndexPaths.count)
        var deletedCount = 0

        recordForDelete: do {
            for (oldIndexForReference, oldIndexPath) in oldIndexPaths.enumerated() {
                deletedOffsets[oldIndexForReference] = deletedCount

                let isDeletedSection = oldSectionReferences[oldIndexPath.sectionIndex] == nil
                if isDeletedSection {
                    continue
                }
                
                let oldReference = oldReferences[oldIndexForReference]
                if oldReference == nil {
                    steps.append(.delete(oldIndexPath))
                    deletedCount += 1
                }
            }
        }
        
        recordInsertOrMoveAndUpdate: do {
            var insertedCount = 0
            for (newIndexPathOffset, newIndexPath) in newIndexPaths.enumerated() {
                guard let oldSectionIndex = newSectionReferences[newIndexPath.sectionIndex] else  {
                    // already insert section
                    continue
                }
                
                let newReference = newReferences[newIndexPathOffset]
                switch newReference {
                case nil:
                    steps.append(.insert(newIndexPath))
                    insertedCount += 1
                case let oldIndexPath?:
                    if newIndexPath.shouldUpdate(to: oldIndexPath) {
                        steps.append(.update(newIndexPath))
                    }
                    
                    if let deletedOffset = deletedOffsets[oldIndexPath.sectionIndex]?[oldIndexPath.itemIndex] {
                        if oldIndexPath.sectionIndex != oldSectionIndex ||
                        if (oldIndex - deletedOffset + insertedCount) != newIndex {
                            steps.append(.move(mapMoveSourceOperation(oldIndex), mapMoveTargetOperation(newIndex)))
                        }
                    }
                }
            }
        }
        
        // Record the element updates/moves/insertions.
//        for targetSectionIndex in targetItemsEachSection.indices {
//            // Should not calculate the element updates/moves/insertions in the inserted section.
//            guard let sourceSectionIndex = sectionResult.metadata.targetReferences[targetSectionIndex] else {
//                secondStageSections.append(targetSections[targetSectionIndex])
//                thirdStageSections.append(targetSections[targetSectionIndex])
//                continue
//            }
//
//            var untrackedSourceIndex: Int? = 0
//            let targetElements = targetItemsEachSection[targetSectionIndex]
//            storedSecondAndThirdStageSection: do {
//                let sectionDeleteOffset = sectionResult.metadata.sourceTraces[sourceSectionIndex].deleteOffset
//
//                let secondStageSection = firstStageSections[sourceSectionIndex - sectionDeleteOffset]
//                secondStageSections.append(secondStageSection)
//
//                let thirdStageSection = Section(model: secondStageSection.model, elements: targetElements)
//                thirdStageSections.append(thirdStageSection)
//            }
//
//            for targetElementIndex in targetElements.indices {
//                untrackedSourceIndex = untrackedSourceIndex.flatMap { index in
//                    sourceElementTraces[sourceSectionIndex].suffix(from: index).index { !$0.isTracked }
//                }
//
//                let targetElementPath = ElementPath(element: targetElementIndex, section: targetSectionIndex)
//
//                // If the element source section is recorded as deletion, record its element path as insertion.
//                guard let sourceElementPath = targetElementReferences[targetElementPath],
//                    let movedSourceSectionIndex = sectionResult.metadata.sourceTraces[sourceElementPath.section].reference else {
//                        elementInserted.append(targetElementPath)
//                        continue
//                }
//
//                sourceElementTraces[sourceElementPath].isTracked = true
//
//                compareOldAndNew: do {
//                    let sourceElement = sourceItemsEachSection[sourceElementPath]
//                    let targetElement = targetItemsEachSection[targetElementPath]
//
//                    if !targetElement.isContentEqual(to: sourceElement) {
//                        elementUpdated.append(sourceElementPath)
//                    }
//                }
//
//                do {
//                    if sourceElementPath.section != sourceSectionIndex || sourceElementPath.element != untrackedSourceIndex {
//                        let deleteOffset = sourceElementTraces[sourceElementPath].deleteOffset
//                        let moveSourceElementPath = ElementPath(element: sourceElementPath.element - deleteOffset, section: movedSourceSectionIndex)
//                        elementMoved.append((source: moveSourceElementPath, target: targetElementPath))
//                    }
//                }
//            }
//        }

        


    }
    
    func diff<D: Differenciable, I>(
        from oldElements: [D],
        to newElements: [D],
        mapDeleteOperation: (Int) -> I,
        mapInsertOperation: (Int) -> I,
        mapUpdateOperation: (Int) -> I,
        mapMoveSourceOperation: (Int) -> I,
        mapMoveTargetOperation: (Int) -> I
        ) -> Result<I> {
        var table: [DifferenceIdentifier: Occurence] = [:]
        
        var newReferences: [Int?] = Array(repeating: nil, count: newElements.count)
        var oldReferences: [Int?] = Array(repeating: nil, count: oldElements.count)
        
        setupTable: do {
            for (offset, element) in oldElements.enumerated() {
                let key = element.differenceIdentifier
                switch table[key] {
                case nil:
                    table[key] = Occurence.start(offset)
                case .unique(let oldIndex)?:
                    let reference = IndicesReference([oldIndex, offset])
                    table[key] = .many(reference)
                case .many(let indexies)?:
                    table[key] = .many(indexies.push(offset))
                }
            }
        }
        
        recordRelation: do {
            for (offset, element) in newElements.enumerated() {
                switch table[element.differenceIdentifier] {
                case nil:
                    // The element means to insert after step
                    break
                case .unique(let oldIndex)?:
                    if oldReferences[oldIndex] == nil {
                        newReferences[offset] = oldIndex
                        oldReferences[oldIndex] = offset
                    }
                case .many(let indexies)?:
                    if let oldIndex = indexies.pop() {
                        newReferences[offset] = oldIndex
                        oldReferences[oldIndex] = offset
                    }
                }
            }
        }
        
        
        // Configure Operations
        var steps: [Operation<I>] = []
        
        var deletedOffsets: [Int] = Array(repeating: 0, count: oldElements.count)
        var deletedCount = 0
        
        recordForDelete: do {
            for (oldIndex, oldReference) in oldReferences.enumerated() {
                deletedOffsets[oldIndex] = deletedCount
                if oldReference == nil {
                    steps.append(.delete(mapDeleteOperation(oldIndex)))
                    deletedCount += 1
                }
            }
        }
        
        recordInsertOrMoveAndUpdate: do {
            var insertedCount = 0
            for (newIndex, newReference) in newReferences.enumerated() {
                switch newReference {
                case nil:
                    steps.append(.insert(mapInsertOperation(newIndex)))
                    insertedCount += 1
                case let oldIndex?:
                    let newElement = newElements[newIndex]
                    let oldElement = oldElements[oldIndex]
                    
                    if newElement.shouldUpdate(to: oldElement) {
                        steps.append(.update(mapUpdateOperation(newIndex)))
                    }
                    
                    let deletedOffset = deletedOffsets[oldIndex]
                    if (oldIndex - deletedOffset + insertedCount) != newIndex {
                        steps.append(.move(mapMoveSourceOperation(oldIndex), mapMoveTargetOperation(newIndex)))
                    }
                }
            }
        }
        
        return Result(operations: steps, references: References(old: oldReferences, new: newReferences))
    }
}

func diffSection(from oldSections: [Section], new newSections: [Section]) -> OperationSet {
    let indexPathForOld = oldSections
        .enumerated()
        .flatMap { section -> [DifferenciableIndexPath] in
            section
                .element
                .items
                .enumerated()
                .map { item in
                    DifferenciableIndexPath(
                        uuid: "",
                        section: section.element,
                        item: item.element,
                        sectionIndex: section.offset,
                        itemIndex: item.offset
                        )
            }
    }
    let indexPathForNew = newSections
        .enumerated()
        .flatMap { section -> [DifferenciableIndexPath] in
            section
                .element
                .items
                .enumerated()
                .map { item in
                    DifferenciableIndexPath(
                        uuid: "",
                        section: section.element,
                        item: item.element,
                        sectionIndex: section.offset,
                        itemIndex: item.offset
                    )
            }
    }

    let sectionOperations = Diff().diff(
        from: oldSections,
        to: newSections,
        mapDeleteOperation: { $0 },
        mapInsertOperation: { $0 },
        mapUpdateOperation: { $0 },
        mapMoveSourceOperation: { $0 },
        mapMoveTargetOperation: { $0 }
    ).operations
    let itemOperations = Diff().diff(
        from: indexPathForOld,
        to: indexPathForNew,
        mapDeleteOperation: { indexPathForOld[$0] },
        mapInsertOperation: { indexPathForNew[$0] },
        mapUpdateOperation: { indexPathForNew[$0] },
        mapMoveSourceOperation: { indexPathForOld[$0] },
        mapMoveTargetOperation: { indexPathForNew[$0] }
    ).operations
    
    var operationSet = OperationSet()
    sectionOperations.forEach {
        switch $0 {
        case .insert(let newIndex):
            operationSet.sectionInsert.append(newIndex)
        case .delete(let oldIndex):
            operationSet.sectionDelete.append(oldIndex)
        case .move(let sourceIndex, let targetIndex):
            operationSet.sectionMove.append((source: sourceIndex, target: targetIndex))
        case .update(let newIndex):
            operationSet.sectionUpdate.append(newIndex)
        }
    }
    
    itemOperations.forEach {
        switch $0 {
        case .insert(let newIndex):
            let isContainSectionInsert = operationSet.sectionInsert.contains(newIndex.indexPath.section)
            if isContainSectionInsert {
                // Should only insert section
                return
            }
            operationSet.itemInsert.append(newIndex)
        case .delete(let oldIndex):
            let isContainSectionDelete = operationSet.sectionDelete.contains(oldIndex.indexPath.section)
            if isContainSectionDelete {
                // Should only delete section
                return
            }
            operationSet.itemDelete.append(oldIndex)
        case .move(let sourceIndex, let targetIndex):
            let isContainSectionMove = operationSet.sectionMove.contains(where: { (source, target) in
                return sourceIndex.indexPath.section == source || targetIndex.indexPath.section == target
            })
            if isContainSectionMove {
                // Should only move section
                return
            }
            let isContainSectionInsert = operationSet.sectionInsert.contains(targetIndex.indexPath.section)
            if isContainSectionInsert {
                // Should only insert section
                return
            }

            operationSet.itemMove.append((source: sourceIndex, target: targetIndex))
        case .update(let newIndex):
            let isContainSectionUpdate = operationSet.sectionUpdate.contains(newIndex.indexPath.section)
            if isContainSectionUpdate {
                // Should only delete section
                return
            }
            let isContainSectionInsert = operationSet.sectionInsert.contains(newIndex.indexPath.section)
            if isContainSectionInsert {
                // Should only insert section
                return
            }

            operationSet.itemUpdate.append(newIndex)
        }
    }
    
    return operationSet
}

struct References {
    let old: [Int?]
    let new: [Int?]
}

/// A mutable reference to indices of elements.
final class IndicesReference {
    private var indices: [Int]
    private var position = 0
    
    init(_ indices: [Int]) {
        self.indices = indices
    }
    
    func push(_ index: Int) -> IndicesReference {
        indices.append(index)
        return self
    }
    
    func pop() -> Int? {
        guard position < indices.endIndex else {
            return nil
        }
        defer { position += 1 }
        return indices[position]
    }
}

struct Result<I> {
    let operations: [Operation<I>]
    let references: References
}

