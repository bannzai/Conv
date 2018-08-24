//
//  DifferenciableIndexPath.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

struct DifferenciableIndexPath: Differenciable {
    let section: Section
    let item: ItemDelegate
    
    let sectionIndex: Int
    let itemIndex: Int
    
    var differenceIdentifier: DifferenceIdentifier {
        return item.differenceIdentifier
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return item.shouldUpdate(to: compare)
    }
    
    var indexPath: IndexPath {
        return IndexPath(item: itemIndex, section: sectionIndex)
    }
}

extension DifferenciableIndexPath: CustomStringConvertible {
    var description: String {
        return "section: \(sectionIndex), item: \(itemIndex)"
    }
}
