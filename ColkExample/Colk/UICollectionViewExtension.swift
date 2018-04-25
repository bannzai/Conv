//
//  UICollectionViewExtension.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public extension UICollectionView {
    public func colk() -> Colk {
        let colk = Colk()
        dataSource = colk
        delegate = colk
        colk.collectionView = self
        return Colk()
    }
}

