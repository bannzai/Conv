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
    
    func remove(for item: Int) -> Item
    func insert(_ item: Item, to index: Int)
}

public protocol SectionDelegatable {
    func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets?
    func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
    func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
}

public class SectionImpl: Section {
    public typealias SectionArgument = (Section: SectionImpl, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [Item] = []
    
    public var header: SectionHeaderFooterView?
    public var footer: SectionHeaderFooterView?
    
    public var inset: ((SectionArgument) -> UIEdgeInsets)?
    public var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    public var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    public init(closure: (SectionImpl) -> Void) {
        closure(self)
    }
    
    public func remove(for item: Int) -> Item {
        return items.remove(at: item)
    }
    
    public func insert(_ item: Item, to index: Int) {
        items.insert(item, at: index)
    }
}

extension SectionImpl {
    @discardableResult public func add(item: Item) -> SectionImpl {
        items.append(item)
        return self
    }
    @discardableResult public func add(items: [Item]) -> SectionImpl {
        self.items.append(contentsOf: items)
        return self
    }
    
    @discardableResult public func create<T: UICollectionViewCell>(item closure: (ItemImpl<T>) -> Void) -> SectionImpl {
        return add(item: ItemImpl<T>() { closure($0) } )
    }
    @discardableResult public func create<E, T: UICollectionViewCell>(for elements: [E], items closure: (E, ItemImpl<T>) -> Void) -> SectionImpl {
        let items = elements.map { element in
            ItemImpl<T>() { item in
                closure(element, item)
            }
        }
        
        return add(items: items)
    }
    @discardableResult public func create<T: UICollectionViewCell>(with count: UInt, items closure: ((UInt, ItemImpl<T>) -> Void)) -> SectionImpl {
        return create(for: [UInt](0..<count), items: closure)
    }
}

extension SectionImpl {
    @discardableResult public func create<HeaderOrFooter: UICollectionReusableView>(
        _ kind: SectionHeaderFooterKind,
        headerOrFooter closure: (SectionHeaderFooter<HeaderOrFooter>) -> Void
        ) -> Self {
        
        let headerFooter = SectionHeaderFooter<HeaderOrFooter>(kind: kind)
        closure(headerFooter)
        
        switch kind {
        case .header:
            header = headerFooter
        case .footer:
            footer = headerFooter
        }
        return self
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
