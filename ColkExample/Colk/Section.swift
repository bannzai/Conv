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
    
    var header: SectionImplHeaderFooterViewable? { get }
    var footer: SectionImplHeaderFooterViewable? { get }
    
    mutating func remove(for item: Int) -> CollectionViewItemType
    mutating func insert(_ item: CollectionViewItemType, to index: Int)
}

public protocol SectionDelegatable {
    func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets?
    func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
    func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
}

public struct SectionImpl: Section {
    public typealias SectionArgument = (Section: SectionImpl, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [CollectionViewItemType]
    
    public var header: SectionImplHeaderFooterViewable?
    public var footer: SectionImplHeaderFooterViewable?
    
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


extension SectionImpl: SectionDelegatable {
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
