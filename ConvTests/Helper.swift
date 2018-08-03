//
//  Helper.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/08/03.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol Stub {
    
}

extension Stub {
    func collectionView() -> UICollectionView {
        // Necessary collectionViewLayout
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func cell() -> TestCollectionViewCell {
        return TestCollectionViewCell()
    }
    
    func indexPath() -> IndexPath {
        return IndexPath()
    }

}
