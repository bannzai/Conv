//
//  Diffable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public protocol Differenciable {
    associatedtype DifferenceIdentifier: Hashable
    
    var differenceIdentifier: DifferenceIdentifier { get }
    
    func isEqual(to compare: Self) -> Bool
}

public extension Differenciable where Self: Equatable {
    public func isEqual(to compare: Self) -> Bool {
        return self == compare
    }
}

public extension Differenciable where Self: Hashable {
    var differenceIdentifier: Self {
        return self
    }
}
