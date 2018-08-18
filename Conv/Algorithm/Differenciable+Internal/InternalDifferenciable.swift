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
    private let uuid: String
    init(position: Int, uuid: String) {
        self.position = position
        self.uuid = uuid
    }
    
    var differenceIdentifier: String {
        return description
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return true
    }
}

extension FakeDifference: CustomStringConvertible {
    var description: String {
        return "FakeDifference position: \(position) + uuid: \(uuid)"
    }
}
