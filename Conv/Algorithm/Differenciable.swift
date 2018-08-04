//
//  Diffable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/04.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public typealias DifferenceIdentifier = String
public protocol Differenciable {
    var differenceIdentifier: DifferenceIdentifier { get }
   
    func isEqual(to compare: Differenciable) -> Bool
}

public extension Differenciable {
    public func isEqual(to compare: Self) -> Bool {
        return differenceIdentifier == compare.differenceIdentifier
    }
}

public extension Differenciable where Self: Hashable {
    var differenceIdentifier: Self {
        return self
    }
}
