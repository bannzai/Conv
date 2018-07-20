//
//  Colk.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit


public class Colk: NSObject {
    public weak var collectionView: UICollectionView?
    public var sections: [Section] = []
    public var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    public var indexTitles: ((UICollectionView) -> [String])?
    public var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    
    func itemFor(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}

