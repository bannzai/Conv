//
//  OperationSet.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

struct OperationSet {
    var sectionInsert: [Int] = []
    var sectionUpdate: [Int] = []
    var sectionDelete: [Int] = []
    var sectionMove: [(source: Int, target: Int)] = []
    
    var itemInsert: [DifferenciableIndexPath] = []
    var itemUpdate: [DifferenciableIndexPath] = []
    var itemDelete: [DifferenciableIndexPath] = []
    var itemMove: [(source: DifferenciableIndexPath, target: DifferenciableIndexPath)] = []
    
    init() {
        
    }
}

