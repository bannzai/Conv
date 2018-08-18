//
//  Occurence.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

enum Occurence {
    case unique(Int)
    case many(IndexStack)
    
    static func start(_ index: Int) -> Occurence {
        return .unique(index)
    }
    
}
