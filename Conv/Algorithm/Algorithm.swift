//
//  Algorithm.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

enum ItemOperation {
    
}


enum Operation<I> {
    case insert(I)
    case delete(I)
    case move(I, I)
    case update(I)
}

// FIXME: Counter で管理しなくても oldCounter, newCounter をそれぞれBoolで値を持つ方式でいいかもしれない
// Differenciable ですでに別のHashを持つものは別のものとして扱うようになるから
enum Counter: Equatable {
    case zero
    case one
    case many(Int)
    
    mutating func next() {
        switch self {
        case .zero:
            self = .one
        case .one:
            self = .many(1)
        case .many(let count):
            self = .many(count + 1)
        }
    }
    
    static func == (lhs: Counter, rhs: Counter) -> Bool {
        switch (lhs, rhs) {
        case (.zero, .zero):
            return true
        case (.one, .one):
            return true
        case (.many(let l), .many(let r)):
            return l == r
        case _:
            return false
        }
    }
}

class Entry {
    var oldCounter: Counter = .zero // OC
    var newCounter: Counter = .zero // NC
    // FIXME: ここは配列である必要がない可能性がある
    // Differenciable ですでに別のHashを持つものは別のものとして扱うようになるから
    var oldIndexNumbers: [Int] = [] // OLNO
    
    var isOccursInBoth: Bool {
        return oldCounter != .zero && newCounter != .zero
    }
}

extension Entry {
    enum Case {
        // this case not yet find same element from other elements.
        case symbol(Entry)
        // this case found same element from other elements.
        case index(Int)
    }
}


struct DifferenciableIndexPath: Differenciable {
    let section: Section
    let item: ItemDelegate
    
    let sectionIndex: Int
    let itemIndex: Int
    
    var differenceIdentifier: DifferenceIdentifier {
        return item.differenceIdentifier
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return item.shouldUpdate(to: compare)
    }
    
    var indexPath: IndexPath {
        return IndexPath(item: itemIndex, section: sectionIndex)
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


func diff<D: Differenciable, I>(
    from oldElements: [D],
    to newElements: [D],
    mapDeleteOperation: (Int) -> I,
    mapInsertOperation: (Int) -> I,
    mapUpdateOperation: (Int) -> I,
    mapMoveSourceOperation: (Int) -> I,
    mapMoveTargetOperation: (Int) -> I
    ) -> [Operation<I>] {
    var table: [DifferenceIdentifier: Entry] = [:] // table, line -> T.Iterator.Element.DifferenceIdentifier
    var newDiffEntries: [Entry.Case] = [] // NA
    var oldDiffEntries: [Entry.Case] = [] // OA
    
    // First Step
    for element in newElements {
        let entry: Entry
        switch table[element.differenceIdentifier] {
        case nil:
            entry = Entry()
            table[element.differenceIdentifier] = entry
        case let e?:
            entry = e
        }
        entry.newCounter.next()
        newDiffEntries.append(.symbol(entry))
    }
    
    // Second Step
    for (offset, element) in oldElements.enumerated() {
        let entry: Entry
        switch table[element.differenceIdentifier] {
        case nil:
            entry = Entry()
            table[element.differenceIdentifier] = entry
        case let e?:
            entry = e
        }
        
        entry.newCounter.next()
        entry.oldIndexNumbers.append(offset)
        oldDiffEntries.append(.symbol(entry))
    }
    
    // Third Step
    for (offset, entry) in newDiffEntries.enumerated() {
        switch entry {
        case .symbol(let entry) where entry.isOccursInBoth:
            assert(!entry.oldIndexNumbers.isEmpty)
            let oldIndex = entry.oldIndexNumbers.removeFirst()
            newDiffEntries[offset] = .index(oldIndex)
            oldDiffEntries[oldIndex] = .index(offset)
        case .index:
            continue
        case .symbol:
            continue
        }
    }
    
    // Fourth Step
    let oldDiffEntriesCount = oldDiffEntries.count
    for (i, newEntry) in newDiffEntries.enumerated() {
        switch newEntry {
        case .index(let j) where j < oldDiffEntriesCount - 1:
            guard
                case let .symbol(newEntry) = newDiffEntries[i + 1],
                case let .symbol(oldEntry) = oldDiffEntries[j + 1],
                newEntry === oldEntry
                else  {
                    continue
            }
            
            newDiffEntries[i + 1] = .index(j + 1)
            oldDiffEntries[j + 1] = .index(i + 1)
        case .symbol:
            continue
        case .index:
            continue
        }
    }
    
    // Fifth step
    for (i, newEntry) in newDiffEntries.reversed().enumerated() {
        switch newEntry {
        case .index(let j) where j > 0:
            guard
                case let .symbol(newEntry) = newDiffEntries[i - 1],
                case let .symbol(oldEntry) = oldDiffEntries[j - 1],
                newEntry === oldEntry
                else  {
                    continue
            }
            
            newDiffEntries[i - 1] = .index(j - 1)
            oldDiffEntries[j - 1] = .index(i - 1)
        case .symbol:
            continue
        case .index:
            continue
        }
    }
    
    // Configure Operations
    
    var steps: [Operation<I>] = []
    
    var deletedOffsets: [Int] = []
    var deletedCount = 0

    for (offset, entry) in oldDiffEntries.enumerated() {
        deletedOffsets.append(deletedCount)
        switch entry {
        case .symbol:
            steps.append(.delete(mapDeleteOperation(offset)))
            deletedCount += 1
        case .index:
            continue
        }
    }
    
    var insertedCount = 0
    
    for (offset, entry) in newDiffEntries.enumerated() {
        switch entry {
        case .symbol:
            steps.append(.insert(mapInsertOperation(offset)))
            insertedCount += 1
        case .index(let oldIndex):
            if oldElements[oldIndex].shouldUpdate(to: newElements[offset]) {
                steps.append(.update(mapUpdateOperation(offset)))
            }
            
            let deletedOffset = deletedOffsets[oldIndex]
            if (oldIndex - deletedOffset + insertedCount) != offset {
                steps.append(.move(mapMoveSourceOperation(oldIndex), mapMoveTargetOperation(offset)))
            }
        }
    }

    
    return steps
}
