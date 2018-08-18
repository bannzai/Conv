//
//  Item+Diffrenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/07.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

extension Item: Differenciable {
    public var differenceIdentifier: DifferenceIdentifier {
        return diffElement.differenceIdentifier
    }
    
    public func shouldUpdate(to compare: Differenciable) -> Bool {
        return diffElement.shouldUpdate(to: compare)
    }
}

