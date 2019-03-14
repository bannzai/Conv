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
    func shiftConv() {
        if let convForOverwrite = self.convForOverwrite {
            self.convForOverwrite = nil
            mainConv?.sections.removeAll()
            mainConv?.sections = convForOverwrite.sections
        }
    }
}

extension UICollectionView: _CollectionViewReloadable {
    func reload() {
        if convForOverwrite == nil {
            reloadData()
            return
        }
        
        shiftConv()
        reloadData()
    }
}

extension UICollectionView: _CollectionViewDiffingRelodable {
    func update() {
        guard let convForOverwrite = convForOverwrite else {
            reloadData()
            return
        }
        
        let oldSections: [Section] = mainConv?.sections ?? []
        let newSections: [Section] = convForOverwrite.sections
        
        let operationSet = diffSection(from: oldSections, new: newSections)
        
        let itemDelete = operationSet.itemDelete.map { $0.indexPath }
        let itemInsert = operationSet.itemInsert.map { $0.indexPath }
        let itemMove = operationSet.itemMove
        let itemUpdate = operationSet.itemUpdate.map { $0.indexPath }
        
        let sectionDelete = operationSet.sectionDelete
        let sectionInsert = operationSet.sectionInsert
        let sectionMove = operationSet.sectionMove
        let sectionUpdate = operationSet.sectionUpdate
        
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
    var mainConv: Conv? {
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
    
    var convForOverwrite: Conv? {
        set {
            newValue?.collectionView = self
            
            objc_setAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &UICollectionViewAssociatedObjectHandle.newConvKey) as? Conv
        }
    }
}

