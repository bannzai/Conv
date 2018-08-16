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

    let sectionOperations = diff(
        from: oldSections,
        to: newSections,
        mapDeleteOperation: { $0 },
        mapInsertOperation: { $0 },
        mapUpdateOperation: { $0 },
        mapMoveSourceOperation: { $0 },
        mapMoveTargetOperation: { $0 }
    )
    let itemOperations = diff(
        from: indexPathForOld,
        to: indexPathForNew,
        mapDeleteOperation: { indexPathForOld[$0] },
        mapInsertOperation: { indexPathForNew[$0] },
        mapUpdateOperation: { indexPathForNew[$0] },
        mapMoveSourceOperation: { indexPathForOld[$0] },
        mapMoveTargetOperation: { indexPathForNew[$0] }
    )
    
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

func diff(
    old: [DifferenciableIndexPath],
    new: [DifferenciableIndexPath]
    ) {
    
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

func diff<D: Differenciable, I>(
    from oldElements: [D],
    to newElements: [D],
    mapDeleteOperation: (Int) -> I,
    mapInsertOperation: (Int) -> I,
    mapUpdateOperation: (Int) -> I,
    mapMoveSourceOperation: (Int) -> I,
    mapMoveTargetOperation: (Int) -> I
    ) -> Result<I> {
    var table: [DifferenceIdentifier: Occurence] = [:] // table, line -> T.Iterator.Element.DifferenceIdentifier
    
    var newReferences: [Int?] = Array(repeating: nil, count: newElements.count)
    var oldReferences: [Int?] = Array(repeating: nil, count: oldElements.count)

    // First Step
    setupTable: do {
        for (offset, element) in oldElements.enumerated() {
            switch table[element.differenceIdentifier] {
            case nil:
                table[element.differenceIdentifier] = Occurence.start(offset)
            case .unique(let oldIndex)?:
                let reference = IndicesReference([oldIndex, offset])
                table[element.differenceIdentifier] = .many(reference)
            case .many(let indexies)?:
                table[element.differenceIdentifier] = .many(indexies.push(offset))
            }
        }
    }

    // Second Step
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
