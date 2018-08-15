//
//  Conv.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public final class Conv: NSObject {
    public weak var collectionView: UICollectionView?
    
    public var sections: [Section] = []
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    let uuid: String
    
    public override init() {
        uuid = UUID().uuidString
        super.init()
    }
    
    public init(uuid: String)  {
        self.uuid = uuid
        super.init()
    }
    
    internal var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    internal var indexTitles: ((_ collectionView: UICollectionView) -> [String])?
    internal var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    internal var transitionLayout: ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    internal var shouldUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)?
    internal var didUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)?
    internal var indexPathForPreferredFocusedView: ((_ collectionView: UICollectionView) -> IndexPath?)?
    internal var targetIndexPathForMoveFromItem: ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)?
    internal var targetContentOffset: ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)?
    
}

extension Conv {
    @discardableResult public func didMoveItem(_ closure: @escaping ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)) -> Self {
        self.didMoveItem = closure
        return self
    }
    @discardableResult public func indexTitles(_ closure: @escaping ((_ collectionView: UICollectionView) -> [String])) -> Self {
        self.indexTitles = closure
        return self
    }
    @discardableResult public func indexTitle(_ closure: @escaping ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)) -> Self {
        self.indexTitle = closure
        return self
    }
    @discardableResult public func transitionLayout(_ closure: @escaping ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)) -> Self {
        self.transitionLayout = closure
        return self
    }
    @discardableResult public func shouldUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)) -> Self {
        self.shouldUpdateFocus = closure
        return self
    }
    @discardableResult public func didUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)) -> Self {
        self.didUpdateFocus = closure
        return self
    }
    @discardableResult public func indexPathForPreferredFocusedView(_ closure: @escaping ((_ collectionView: UICollectionView) -> IndexPath?)) -> Self {
        self.indexPathForPreferredFocusedView = closure
        return self
    }
    
    @discardableResult public func targetIndexPathForMoveFromItem(_ closure: @escaping ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ toProposedIndexPath: IndexPath) -> IndexPath)) -> Self {
        self.targetIndexPathForMoveFromItem = closure
        return self
    }
    @discardableResult public func targetContentOffset(_ closure: @escaping ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)) -> Self {
        self.targetContentOffset = closure
        return self
    }
}

extension Conv {
    @discardableResult public func create(section closure: (Section) -> Void) -> Self {
        create(for: [FakeDifference()]) { (_, section) in
            closure(section)
        }
        
        return self
    }
    
    @discardableResult public func create<E: Differenciable>(for elements: [E], sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section(diffElement: element) { section in
                closure(element, section)
            }
        }
        
        self.sections.append(contentsOf: sections)
        return self
    }
}

