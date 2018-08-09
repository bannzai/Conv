//
//  ItemDelegate.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol ItemDelegate: Reusable, Differenciable {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize?
    
    func canMoveItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    
    func willDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    func didEndDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    
    func shouldHighlight(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func didHighlight(collectionView: UICollectionView, indexPath: IndexPath)
    func didUnhighlight(collectionView: UICollectionView, indexPath: IndexPath)
    
    func shouldSelect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func shouldDeselect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func didSelect(collectionView: UICollectionView, indexPath: IndexPath)
    func didDeselect(collectionView: UICollectionView, indexPath: IndexPath)
    
    func shouldShowMenu(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func canPerformAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool?
    func performAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?)
    
    func canFocusItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
}

