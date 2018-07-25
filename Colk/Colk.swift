//
//  Colk.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public final class Colk: NSObject {
    public weak var collectionView: UICollectionView?
    
    public var sections: [Section] = []
    public var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    public var indexTitles: ((UICollectionView) -> [String])?
    public var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    public var transitionLayout: ((UICollectionView, UICollectionViewLayout, UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    public var shouldUpdateFocus: ((UICollectionView, UICollectionViewFocusUpdateContext) -> Bool)?
    public var didUpdateFocus: ((UICollectionView, UICollectionViewFocusUpdateContext, UIFocusAnimationCoordinator) -> Void)?
    public var indexPathForPreferredFocusedView: ((UICollectionView) -> IndexPath?)?
}

extension Colk {
    @discardableResult public func add(section: Section) -> Self {
        sections.append(section)
        return self
    }
    @discardableResult public func add(sections: [Section]) -> Self {
        self.sections.append(contentsOf: sections)
        return self
    }
    
    @discardableResult public func create(section closure: (Section) -> Void) -> Self {
        return add(section: Section() { closure($0) } )
    }
    @discardableResult public func create<E>(for elements: [E], sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section() { section in
                closure(element, section)
            }
        }
        
        return add(sections: sections)
    }
    @discardableResult public func create(with count: UInt, sections closure: ((UInt, Section) -> Void)) -> Self {
        return create(for: [UInt](0..<count), sections: closure)
    }
}

