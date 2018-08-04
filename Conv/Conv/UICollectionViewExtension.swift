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
        switch (oldConv, newConv) {
        case (nil, _):
            self.oldConv = conv
        case (_, _):
            self.newConv = conv
        }
        return conv
    }
    
    public func conv(scrollViewDelegate: UIScrollViewDelegate?) -> Conv {
        let conv = self.conv()
        conv.scrollViewDelegate = scrollViewDelegate
        return conv
    }
    
    public func reload() {
        if let newConv = newConv {
            newConv.reload()
            return
        }
        
        oldConv?.reload()
    }
}

fileprivate struct UICollectionViewAssociatedObjectHandle {
    static var oldConvKey: UInt8 = 0
    static var newConvKey: UInt8 = 0
}

fileprivate extension UICollectionView {
    var oldConv: Conv? {
        set {
            dataSource = newValue
            delegate = newValue
            newValue?.collectionView = self
            
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.oldConvKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.oldConvKey) as? Conv
        }
    }
    
    var newConv: Conv? {
        set {
            dataSource = newValue
            delegate = newValue
            newValue?.collectionView = self
            
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey) as? Conv
        }
    }
}

