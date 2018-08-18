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
        switch (oldConv, newConv) {
        case (nil, nil):
            let conv = Conv()
            self.oldConv = conv
            return conv
        case (nil, let newConv?):
            let conv = Conv(uuid: newConv.uuid)
            self.newConv = conv
            return conv
        case (let oldConv?, _):
            let conv = Conv(uuid: oldConv.uuid)
            self.newConv = conv
            return conv
        }
    }
    
    public func conv(scrollViewDelegate: UIScrollViewDelegate?) -> Conv {
        let conv = self.conv()
        conv.scrollViewDelegate = scrollViewDelegate
        return conv
    }
    
    func shiftConv() {
        if let newConv = self.newConv {
            self.newConv = nil
            oldConv?.sections.removeAll()
            oldConv?.sections = newConv.sections
        }
    }
    
    public func reload() {
        guard let newConv = newConv else {
            reloadData()
            return
        }
        
        let oldSections: [Section] = oldConv?.sections ?? []
        let newSections: [Section] = newConv.sections
        
        let operationSet = diffSection(from: oldSections, new: newSections)
        
        let itemDelete = operationSet.itemDelete.map { $0.indexPath }
        let itemInsert = operationSet.itemInsert.map { $0.indexPath }
        let itemMove = operationSet.itemMove
        let itemUpdate = operationSet.itemUpdate.map { $0.indexPath }
        
        let sectionDelete = operationSet.sectionDelete
        let sectionInsert = operationSet.sectionInsert
        let sectionMove = operationSet.sectionMove
        let sectionUpdate = operationSet.sectionUpdate
        
        print("operationSet: \(operationSet)")
        
        shiftConv()
        
        performBatchUpdates({
            if !sectionDelete.isEmpty {
                deleteSections(IndexSet(sectionDelete))
            }
            if !sectionInsert.isEmpty {
                insertSections(IndexSet(sectionInsert))
            }
            if !sectionMove.isEmpty {
                sectionMove.forEach {
                    moveSection($0.source, toSection: $0.target)
                }
            }
            
            if !itemDelete.isEmpty {
                deleteItems(at: itemDelete)
            }
            if !itemInsert.isEmpty {
                insertItems(at: itemInsert)
            }
            if !itemMove.isEmpty {
                itemMove.forEach {
                    moveItem(at: $0.source.indexPath, to: $0.target.indexPath)
                }
            }
            
            if !sectionUpdate.isEmpty {
                reloadSections(IndexSet(sectionUpdate))
            }
            if !itemUpdate.isEmpty {
                reloadItems(at: itemUpdate)
            }
        })
        
    }
}

fileprivate struct UICollectionViewAssociatedObjectHandle {
    static var oldConvKey: UInt8 = 0
    static var newConvKey: UInt8 = 0
}

extension UICollectionView {
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
            newValue?.collectionView = self
            
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey) as? Conv
        }
    }
}

