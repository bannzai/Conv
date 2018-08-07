//
//  Algorithm.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

struct RepresentModel {
    let secton: Int
    let item: [Int]
}

struct Operations {
    let parent: Operation
    let children: [Operation]
}

enum Operation {
    case insert(Int)
    case delete(Int)
    case move(Int, Int)
    
    
    // update has oldIndex and newIndex
    // If Differenciable is Section, call diff again for items.
    case update(Int, Int)
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
    var differenceIdentifier: DifferenceIdentifier {
        return section.differenceIdentifier + items.reduce(DifferenceIdentifier(), { return $0 + $1.differenceIdentifier })
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        assert(compare is DifferenciableIndexPath)
        return differenceIdentifier != compare.differenceIdentifier
    }
    
    let section: Section
    let items: [ItemDelegate]
    
    init(section: Section) {
        self.section = section
        self.items = section.items
    }
}

func diffSection(from oldSections: [Section], to newSections: [Section]) -> [Operation] {
    let indexPathForOld = oldSections.map { DifferenciableIndexPath(section: $0) }
    let indexPathForNew = newSections.map { DifferenciableIndexPath(section: $0) }
    let sectionOperations = diff(from: indexPathForOld, to: indexPathForNew)
    
    
}

func diff(from oldElements: [Differenciable], to newElements: [Differenciable]) -> [Operation] {
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
    
    var steps: [Operation] = []
    
    var deletedOffsets: [Int] = []
    var deletedCount = 0

    for (offset, entry) in oldDiffEntries.enumerated() {
        deletedOffsets.append(deletedCount)
        switch entry {
        case .symbol:
            steps.append(.delete(offset))
            deletedCount += 1
        case .index:
            continue
        }
    }
    
    var insertedCount = 0
    
    for (offset, entry) in newDiffEntries.enumerated() {
        switch entry {
        case .symbol:
            steps.append(.insert(offset))
            insertedCount += 1
        case .index(let oldIndex):
            if oldElements[oldIndex].shouldUpdate(to: newElements[offset]) {
                steps.append(.update(oldIndex, offset))
            }
            
            let deletedOffset = deletedOffsets[oldIndex]
            if (oldIndex - deletedOffset + insertedCount) != offset {
                steps.append(.move(oldIndex, offset))
            }
        }
    }

    
    return steps
}
