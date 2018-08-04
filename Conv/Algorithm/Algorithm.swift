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

struct TableKey<T: Hashable>: Hashable {
    let hashValue: Int
    
    init(reference: T) {
        self.hashValue = reference.hashValue
    }
    
    static func == (lhs: TableKey, rhs: TableKey) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

public func diff<T: Collection>(from old: T, to new: T) -> [Operation] where T.Iterator.Element: Differenciable, T.Index == Int {

    return []
}
