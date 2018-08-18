//
//  IndexStack.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

final class IndexStack {
    private var indices: [Int]
    private var position = 0
    
    init(_ indices: [Int]) {
        self.indices = indices
    }
    
    func push(_ index: Int) -> IndexStack {
        indices.append(index)
        return self
    }
    
    func pop() -> Int? {
        if indices.isEmpty {
            return nil
        }
        return indices.removeFirst()
    }
}

