//
//  Section+Differenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/05.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

extension Section: Differenciable {
    public func shouldUpdate(to compare: Differenciable) -> Bool {
        return diffElement.shouldUpdate(to: compare)
    }
    
    public var differenceIdentifier: DifferenceIdentifier {
        return diffElement.differenceIdentifier
    }
}
