//
//  Section.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public class AbstractSection {
    public typealias SectionArgument = (Section: AbstractSection, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [ItemDelegate] = []

    public var header: SectionHeaderFooterDelegate?
    public var footer: SectionHeaderFooterDelegate?
    public var custom: SectionHeaderFooterDelegate?
    
    internal var inset: ((SectionArgument) -> UIEdgeInsets)?
    internal var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    internal var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    init() {
        
    }

    @discardableResult public func remove(at item: Int) -> ItemDelegate {
        return items.remove(at: item)
    }
    
    public func insert(_ item: ItemDelegate, to index: Int) {
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

extension AbstractSection {
    @discardableResult public func append<HeaderOrFooter: UICollectionReusableView>(
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
        case .custom:
            custom = headerFooter
        }
        return self
    }
}

public final class Section: AbstractSection {
    public init(closure: (Section) -> Void) {
        super.init()
        closure(self)
    }
}

extension Section {
    @discardableResult public func append<T: UICollectionViewCell>(item closure: (Item<T>) -> Void) -> Section {
        append(for: [FakeDifference()]) { (_, item) in
            closure(item)
        }
        
        return self
    }
    
    @discardableResult public func append<E: Differenciable, T: UICollectionViewCell>(for elements: [E], items closure: (E, Item<T>) -> Void) -> Section {
        let items = elements.map { element in
            Item<T>(diffElement: element) { item in
                closure(element, item)
            }
        }
        
        self.items.append(contentsOf: items)
        return self
    }
}

public final class DiffSection: AbstractSection {
    public let diffElement: Differenciable
    public init(diffElement: Differenciable, closure: (DiffSection) -> Void) {
        self.diffElement = diffElement
        super.init()
        closure(self)
    }
}

extension DiffSection {
    @discardableResult public func append<T: UICollectionViewCell>(with differenceIdentifier: DifferenceIdentifier, item closure: (Item<T>) -> Void) -> DiffSection {
        append(for: [FakeDifference()]) { (_, item) in
            closure(item)
        }
        return self
    }
    
    @discardableResult public func append<E: Differenciable, T: UICollectionViewCell>(for elements: [E], items closure: (E, Item<T>) -> Void) -> DiffSection {
        let items = elements.map { element in
            Item<T>(diffElement: element) { item in
                closure(element, item)
            }
        }
        
        self.items.append(contentsOf: items)
        return self
    }
}
