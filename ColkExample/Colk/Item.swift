//
//  Item.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol ItemType {
    var reusableIdentifier: String { get set }
}

public protocol ItemDelegatable {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize
}

public struct Item<T: UICollectionViewCell>: ItemType {
    public typealias ItemInfomation = (item: Item<T>, collectionView: UICollectionView, indexPath: IndexPath)
    public var reusableIdentifier: String
    
    public var configureCell: ((T, ItemInfomation) -> Void)?
    public var sizeFor: ((ItemInfomation) -> CGSize)?
}

extension Item: ItemDelegatable {
    public func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        configureCell?(cell as! T, (self, collectionView, indexPath))
    }
    
    public func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize {
        guard let size = sizeFor?((self, collectionView, indexPath)) else {
            return .zero
        }
        
        return size
    }
}

