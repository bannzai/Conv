//
//  UICollectionViewExtension.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import ObjectiveC

public extension UICollectionView {
    public func conv() -> Conv {
        let conv = Conv()
        _conv = conv
        return conv
    }
    
    public func conv(scrollViewDelegate: UIScrollViewDelegate?) -> Conv {
        let conv = Conv(scrollViewDelegate: scrollViewDelegate)
        _conv = conv
        return conv
    }
}

fileprivate struct UICollectionViewAssociatedObjectHandle {
    static var key: UInt8 = 0
}

fileprivate extension UICollectionView {
    var _conv: Conv? {
        set {
            dataSource = newValue
            delegate = newValue
            newValue?.collectionView = self
            
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.key) as? Conv
        }
    }
}

