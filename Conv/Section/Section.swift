//
//  Section.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public class Section {
    public typealias SectionArgument = (Section: Section, collectionView: UICollectionView, collectionViewLayout: UICollectionViewLayout, section: Int)
    public var items: [ItemDelegate] = []
    public var diffElement: Differenciable!
    
    public var header: SectionHeaderFooterDelegate?
    public var footer: SectionHeaderFooterDelegate?
    public var custom: SectionHeaderFooterDelegate?
    
    internal var inset: ((SectionArgument) -> UIEdgeInsets)?
    internal var minimumLineSpacing: ((SectionArgument) -> CGFloat)?
    internal var minimumInteritemSpacing: ((SectionArgument) -> CGFloat)?
    
    init() {
        
    }

    public init(diffElement: Differenciable, closure: (Section) -> Void) {
        self.diffElement = diffElement
        closure(self)
    }
    
    @discardableResult public func remove(at item: Int) -> ItemDelegate {
        return items.remove(at: item)
    }
    
    public func insert(_ item: ItemDelegate, to index: Int) {
        items.insert(item, at: index)
    }
}

// MARK: - Function for Section
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

// MARK: - Delete
extension Section {
    @discardableResult public func delete(at index: Int) -> Self {
        items.remove(at: index)
        return self
    }
    
    @discardableResult public func delete<E: Differenciable>(for element: E) -> Self {
        items.removeAll { (item) -> Bool in
            item.differenceIdentifier == element.differenceIdentifier
        }
        return self
    }
    
    @discardableResult public func delete<E: Differenciable>(for elements: [E]) -> Self {
        elements.forEach { delete(for: $0) }
        return self
    }
}

// MARK: - Insert
extension Section {
    @discardableResult public func insert<E, T: UICollectionViewCell>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for element: E,
        at index: Int,
        item closure: (E, Item<T>) -> Void
        ) -> Section {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: index,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        
        let item = Item<T>(diffElement: fake) { (item) in
            closure(element, item)
        }
        
        self.items.insert(item, at: index)
        return self
    }
    
    @discardableResult public func insert<E, T: UICollectionViewCell>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for elements: [E],
        at index: Int,
        items closure: (E, Item<T>) -> Void
        ) -> Section {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: index,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        
        let items = elements.map { (element) in
            Item<T>(diffElement: fake) { item in
                closure(element, item)
            }
        }
        
        self.items.insert(contentsOf: items, at: index)
        return self
    }

    @discardableResult public func insert<E: Differenciable, T: UICollectionViewCell>(for element: E, at index: Int, item closure: (E, Item<T>) -> Void) -> Section {
        insert(for: [element], at: index) { (element, item) in
            closure(element, item)
        }
        return self
    }
    
    @discardableResult public func insert<E: Differenciable, T: UICollectionViewCell>(for elements: [E], at index: Int, items closure: (E, Item<T>) -> Void) -> Section {
        let items = elements.map { element in
            Item<T>(diffElement: element) { item in
                closure(element, item)
            }
        }
        
        self.items.insert(contentsOf: items, at: index)
        return self
    }
}


// MARK: - Append
extension Section {
    @discardableResult public func append<T: UICollectionViewCell>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        item closure: (Item<T>) -> Void
        ) -> Section {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: items.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        append(for: fake) { (_, item) in
            closure(item)
        }
        return self
    }
    
    @discardableResult public func append<E, T: UICollectionViewCell>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        element: E,
        item closure: (E, Item<T>) -> Void
        ) -> Section {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: items.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        let item = Item<T>(diffElement: fake) { (item) in
            closure(element, item)
        }
        self.items.append(item)
        return self
    }
    
    @discardableResult public func append<E, T: UICollectionViewCell>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        elements: [E],
        item closure: (E, Item<T>) -> Void
        ) -> Section {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: self.items.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        let items = elements.map { element in
            Item<T>(diffElement: fake) { item in
                closure(element, item)
            }
        }
        
        self.items.append(contentsOf: items)
        return self
    }

    @discardableResult public func append<E: Differenciable, T: UICollectionViewCell>(for element: E, item closure: (E, Item<T>) -> Void) -> Section {
        append(for: [element]) { (element, item) in
            closure(element, item)
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

extension Section {
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
