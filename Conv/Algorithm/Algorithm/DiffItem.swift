//
//  DiffItem.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
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
            
            
            let isAlreadyInsertedSection = newSectionReferences[newIndexPath.sectionIndex] == nil
            if isAlreadyInsertedSection {
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



