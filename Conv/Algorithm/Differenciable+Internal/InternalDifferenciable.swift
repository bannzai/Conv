//
//  Int+Differenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/05.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

fileprivate var callCount = 0
internal struct FakeDifference: Differenciable {
    init() {
        callCount += 1
    }
    
    var differenceIdentifier: String {
        return description
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return false
    }
}

extension FakeDifference: CustomStringConvertible {
    var description: String {
        return "FakeDifference: \(callCount)"
    }
}
