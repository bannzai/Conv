//
//  Helper.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/08/03.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
@testable import Conv

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

struct Model: Differenciable {
    let id: Int
    let isNecessaryUpdate: Bool
    
    var differenceIdentifier: DifferenceIdentifier {
        return "\(id)"
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return isNecessaryUpdate
    }
}

func make(_ id: Int) -> Model {
    return Model(id: id, isNecessaryUpdate: false)
}

func makeForUpdate(_ id: Int, _ shouldUpdate: Bool) -> Model {
    return Model(id: id, isNecessaryUpdate: shouldUpdate)
}
