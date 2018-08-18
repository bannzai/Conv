//
//  Diff.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

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
