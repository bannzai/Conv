//
//  Section.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol SectionDelegatable {
    func inset(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> UIEdgeInsets?
    func minimumLineSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
    func minimumInteritemSpacing(collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int) -> CGFloat?
}

public class Section {
    public typealias SectionArgument = (Section: Section, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [ItemDelegatable] = []
    
    public var header: SectionHeaderFooter?
    public var footer: SectionHeaderFooter?
    
    internal var inset: ((SectionArgument) -> UIEdgeInsets)?
    internal var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    internal var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    public init(closure: (Section) -> Void) {
        closure(self)
    }
    
    public func remove(for item: Int) -> ItemDelegatable {
        return items.remove(at: item)
    }
    
    public func insert(_ item: ItemDelegatable, to index: Int) {
        items.insert(item, at: index)
    }
}

extension Section {
    public func inset(_ closure: @escaping ((SectionArgument) -> UIEdgeInsets)) {
        self.inset = closure
    }
    public func minimumLineSpacing(_ closure: @escaping ((SectionArgument) -> CGFloat)) {
        self.minimumLineSpacing = closure
    }
    public func minimumInteritemSpacing(_ closure: @escaping ((SectionArgument) -> CGFloat)) {
        self.minimumInteritemSpacing = closure
    }
}

extension Section {
    @discardableResult public func add(item: ItemDelegatable) -> Section {
        items.append(item)
        return self
    }
    @discardableResult public func add(items: [ItemDelegatable]) -> Section {
        self.items.append(contentsOf: items)
        return self
    }
    
    @discardableResult public func create<T: UICollectionViewCell>(item closure: (Item<T>) -> Void) -> Section {
        return add(item: Item<T>() { closure($0) } )
    }
    @discardableResult public func create<E, T: UICollectionViewCell>(for elements: [E], items closure: (E, Item<T>) -> Void) -> Section {
        let items = elements.map { element in
            Item<T>() { item in
                closure(element, item)
            }
        }
        
        return add(items: items)
    }
    @discardableResult public func create<T: UICollectionViewCell>(with count: UInt, items closure: ((UInt, Item<T>) -> Void)) -> Section {
        return create(for: [UInt](0..<count), items: closure)
    }
}

extension Section {
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

extension Section: SectionDelegatable {
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
