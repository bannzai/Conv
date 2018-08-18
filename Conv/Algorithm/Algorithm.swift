//
//  Algorithm.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

func diffItem(
    from oldIndexPaths: [DifferenciableIndexPath],
    to newIndexPaths: [DifferenciableIndexPath],
    oldSectionReferences: [Int?],
    newSectionReferences: [Int?],
    movedIndexies: [(old: Int, new: Int)]
    ) -> SectionResult<DifferenciableIndexPath> {
    var table: [DifferenceIdentifier: Occurence] = [:]

    var oldReferences: [Int?] = Array(repeating: nil, count: oldIndexPaths.count)
    var newReferences: [Int?] = Array(repeating: nil, count: newIndexPaths.count)

    setupTable: do {
        for (offset, oldIndexPath) in oldIndexPaths.enumerated() {
            let key = oldIndexPath.differenceIdentifier
            switch table[key] {
            case nil:
                table[key] = Occurence.start(offset)
            case .unique(let oldIndex)?:
                let reference = IndexStack([oldIndex, offset])
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

    var steps: [Operation<DifferenciableIndexPath>] = []

    var deletedOffsets: [Int] = Array(repeating: 0, count: oldIndexPaths.count)
    var deletedCount = 0
    var deletedOffsetEachSection: [Int: [Int]] = [:]

    recordForDelete: do {
        for (oldIndexForReference, oldIndexPath) in oldIndexPaths.enumerated() {
            deletedOffsets[oldIndexForReference] = deletedCount
            if deletedOffsetEachSection[oldIndexPath.sectionIndex] == nil {
                deletedCount = 0
                deletedOffsetEachSection[oldIndexPath.sectionIndex] = []
            }
            deletedOffsetEachSection[oldIndexPath.sectionIndex]?.append(deletedCount)

            let isDeletedSection = oldSectionReferences[oldIndexPath.sectionIndex] == nil
            if isDeletedSection {
                // Only exec delete section when section deleted
                continue
            }

            let isExistsIndexPathAtNew = oldReferences[oldIndexForReference] != nil
            if isExistsIndexPathAtNew {
                // if exists new index path, skip recording for remove index path
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
        var savedSectionForResetInsertedCount = 0
        for (newIndexPathOffset, newIndexPath) in newIndexPaths.enumerated() {
            if savedSectionForResetInsertedCount != newIndexPath.sectionIndex {
                insertedCount = 0
                savedSectionForResetInsertedCount = newIndexPath.sectionIndex
            }

            guard let oldSectionIndex = newSectionReferences[newIndexPath.sectionIndex] else  {
                // Already insert section
                continue
            }

            guard let oldIndex = newReferences[newIndexPathOffset], let movedSectionIndex = oldSectionReferences[oldIndexPaths[oldIndex].sectionIndex] else {
                steps.append(.insert(newIndexPath))
                insertedCount += 1
                continue
            }

            let oldIndexPath = oldIndexPaths[oldIndex]

            if newIndexPath.shouldUpdate(to: oldIndexPath) {
                steps.append(.update(newIndexPath))
            }

            let deletedOffset = deletedOffsetEachSection[oldIndexPath.sectionIndex]![oldIndexPath.itemIndex]
//                let deletedOffset = deletedOffsets[oldIndex]

            let containsMovedSection = movedIndexies.contains { (old, new) -> Bool in
                return old == oldIndexPath.sectionIndex && new == newIndexPath.sectionIndex
            }

            if containsMovedSection {
                continue
            }

            // The object is not at the expected position, so move it.
            if oldIndexPath.sectionIndex != movedSectionIndex || (oldIndex - deletedOffset + insertedCount) != newIndexPathOffset {
                steps.append(.move(oldIndexPath, newIndexPath))
            }
        }
    }

    return SectionResult(operations: steps, SectionReference: SectionReference(old: oldReferences, new: newReferences))
}

func diff<D: Differenciable, I>(
    from oldElements: [D],
    to newElements: [D],
    mapDeleteOperation: (Int) -> I,
    mapInsertOperation: (Int) -> I,
    mapUpdateOperation: (Int) -> I,
    mapMoveSourceOperation: (Int) -> I,
    mapMoveTargetOperation: (Int) -> I
    ) -> SectionResult<I> {
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
                let reference = IndexStack([oldIndex, offset])
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

    return SectionResult(operations: steps, SectionReference: SectionReference(old: oldReferences, new: newReferences))
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

    let sectionResult = diff(
        from: oldSections,
        to: newSections,
        mapDeleteOperation: { $0 },
        mapInsertOperation: { $0 },
        mapUpdateOperation: { $0 },
        mapMoveSourceOperation: { $0 },
        mapMoveTargetOperation: { $0 }
    )
    let sectionOperations = sectionResult.operations
    
    let movedIndexies: [(old: Int, new: Int)] = sectionOperations.compactMap {
        switch $0 {
        case .move(let old, let new):
            return (old: old, new: new)
        case _:
            return nil
        }
    }

    let itemOperations = diffItem(
        from: indexPathForOld,
        to: indexPathForNew,
        oldSectionReferences: sectionResult.SectionReference.old,
        newSectionReferences: sectionResult.SectionReference.new,
        movedIndexies: movedIndexies
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
            operationSet.itemInsert.append(newIndex)
        case .delete(let oldIndex):
            operationSet.itemDelete.append(oldIndex)
        case .move(let sourceIndex, let targetIndex):
            operationSet.itemMove.append((source: sourceIndex, target: targetIndex))
        case .update(let newIndex):
            operationSet.itemUpdate.append(newIndex)
        }
    }
    
    return operationSet
}

