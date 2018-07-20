//
//  Section.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol Section {
    var items: [Item] { get set }
    
    var header: SectionHeaderFooterView? { get }
    var footer: SectionHeaderFooterView? { get }
    
    mutating func remove(for item: Int) -> Item
    mutating func insert(_ item: Item, to index: Int)
}

public protocol SectionDelegatable {
    func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets?
    func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
    func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
}

public struct SectionImpl: Section {
    public typealias SectionArgument = (Section: SectionImpl, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [Item] = []
    
    public var header: SectionHeaderFooterView?
    public var footer: SectionHeaderFooterView?
    
    public var inset: ((SectionArgument) -> UIEdgeInsets)?
    public var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    public var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    public init(closure: (inout SectionImpl) -> Void) {
        closure(&self)
    }
    
    public mutating func remove(for item: Int) -> Item {
        return items.remove(at: item)
    }
    
    public mutating func insert(_ item: Item, to index: Int) {
        items.insert(item, at: index)
    }
}

extension SectionImpl {
    public mutating func add(item: Item) -> SectionImpl {
        items.append(item)
        return self
    }
    public mutating func add(items: [Item]) -> SectionImpl {
        self.items.append(contentsOf: items)
        return self
    }
    
    public mutating func create(item closure: (Item) -> Void) -> SectionImpl {
        return add(item: ItemImpl() { closure($0) } )
    }
    public mutating func create<E>(for elements: [E], items closure: (E, Item) -> Void) -> SectionImpl {
        let items = elements.map { element in
            ItemImpl() { item in
                closure(element, item)
            }
        }
        
        return add(items: items)
    }
    public mutating func createSections(for count: UInt, items closure: ((UInt, Item) -> Void)) -> SectionImpl {
        return create(for: [UInt](0..<count), items: closure)
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
