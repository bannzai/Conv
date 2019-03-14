//
//  Int+Differenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/05.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

internal struct FakeDifference: Differenciable {
    private let position: Int
    private let _differenceIdentifier: DifferenceIdentifier
    init(position: Int, differenceIdentifier: DifferenceIdentifier) {
        self.position = position
        self._differenceIdentifier = differenceIdentifier
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return false
    }
    
    var differenceIdentifier: String {
        return description
    }
}

extension FakeDifference: CustomStringConvertible {
    var description: String {
        return "FakeDifference position: \(position) + _differenceIdentifier: \(_differenceIdentifier)"
    }
}
