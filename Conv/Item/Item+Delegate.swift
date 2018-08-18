//
//  Item+ItemDelegate.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

extension Item: ItemDelegate {
    public func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        configureCell?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        return sizeFor?((self, collectionView, indexPath)) ?? size
    }
    
    public func canMoveItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return canMoveItem?((self, collectionView, indexPath))
    }
    
    public func willDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        willDisplay?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func didEndDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        didEndDisplay?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func shouldHighlight(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldHighlight?((self, collectionView, indexPath))
    }
    
    public func didHighlight(collectionView: UICollectionView, indexPath: IndexPath) {
        didHighlight?((self, collectionView, indexPath))
    }
    
    public func didUnhighlight(collectionView: UICollectionView, indexPath: IndexPath) {
        didUnhighlight?((self, collectionView, indexPath))
    }
    
    public func shouldSelect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldSelect?((self, collectionView, indexPath))
    }
    
    public func shouldDeselect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldDeselect?((self, collectionView, indexPath))
    }
    
    public func didSelect(collectionView: UICollectionView, indexPath: IndexPath) {
        didSelect?((self, collectionView, indexPath))
    }
    
    public func didDeselect(collectionView: UICollectionView, indexPath: IndexPath) {
        didDeselect?((self, collectionView, indexPath))
    }
    
    public func shouldShowMenu(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldShowMenu?((self, collectionView, indexPath))
    }
    
    public func canPerformAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool? {
        return canPerformAction?((self, collectionView, action, indexPath, sender))
    }
    
    public func performAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?((self, collectionView, action, indexPath, sender))
    }
    
    public func canFocusItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return canFocusItem?((self, collectionView, indexPath))
    }
}
