//
//  UICollectionViewExtension.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import ObjectiveC

public extension UICollectionView {
    public func colk() -> Colk {
        if let colk = _colk {
            return colk
        }
        
        let colk = Colk()
        dataSource = colk
        delegate = colk
        colk.collectionView = self
        return colk
    }
}

fileprivate struct UICollectionViewAssociatedObjectHandle {
    static var key: UInt8 = 0
}

fileprivate extension UICollectionView {
    var _colk: Colk? {
        set {
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            dataSource = newValue
            delegate = newValue
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.key) as? Colk
        }
    }
}

