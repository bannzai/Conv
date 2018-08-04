//
//  Int+Differenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/05.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

internal struct FakeDifference: Differenciable {
    typealias DifferenceIdentifier = String

    var differenceIdentifier: String {
        return "FakeDifference"
    }
    
    func isEqual(to compare: FakeDifference) -> Bool {
        return false
    }
}
