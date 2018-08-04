//
//  Algorithm.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public enum Operation: Equatable {
    case insert(Int)
    case delete(Int)
    case move(Int, Int)
    case update(Int)
    
    public static func ==(lhs: Operation, rhs: Operation) -> Bool {
        switch (lhs, rhs) {
        case let (.insert(l), .insert(r)),
             let (.delete(l), .delete(r)),
             let (.update(l), .update(r)):
            return l == r
        case let (.move(l), .move(r)):
            return l == r
        case _:
            return false
        }
    }
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


public func diff<T: Collection>(from oldElements: T, to newElements: T) -> [Operation] where T.Iterator.Element: Differenciable, T.Index == Int {
    var table: [T.Iterator.Element.DifferenceIdentifier: Entry] = [:] // table, line -> T.Iterator.Element.DifferenceIdentifier
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
    

    return []
}
