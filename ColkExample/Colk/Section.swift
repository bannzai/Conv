//
//  Section.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol Section {
    var items: [CollectionViewItemType] { get set }
    
    var header: CollectionViewSectionHeaderFooterViewable? { get }
    var footer: CollectionViewSectionHeaderFooterViewable? { get }
    
    mutating func remove(for item: Int) -> CollectionViewItemType
    mutating func insert(_ item: CollectionViewItemType, to index: Int)
}

public protocol CollectionViewSectionDelegatable {
    func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets?
    func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
    func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
}

public struct CollectionViewSection: Section {
    public typealias SectionArgument = (Section: CollectionViewSection, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [CollectionViewItemType]
    
    public var header: CollectionViewSectionHeaderFooterViewable?
    public var footer: CollectionViewSectionHeaderFooterViewable?
    
    public var inset: ((SectionArgument) -> UIEdgeInsets)?
    public var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    public var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    public mutating func remove(for item: Int) -> CollectionViewItemType {
        return items.remove(at: item)
    }
    
    public mutating func insert(_ item: CollectionViewItemType, to index: Int) {
        items.insert(item, at: index)
    }
}


extension CollectionViewSection: CollectionViewSectionDelegatable {
    public func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets? {
        return inset?((self, collectionView, collectionViewLayout, section))
    }
    public func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat? {
        return minimumLineSpacing?((self, collectionView, collectionViewLayout, section))
    }
    public func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat? {
        return minimumInteritemSpacing?((self, collectionView, collectionViewLayout, section))
    }
}
