//
//  Operation.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

enum Operation<I> {
    case insert(I)
    case delete(I)
    case move(I, I)
    case update(I)
}

