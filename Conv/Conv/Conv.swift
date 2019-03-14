//
//  Conv.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol ConvInterface: class {
    @discardableResult func didMoveItem(_ closure: @escaping ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)) -> Self
    @discardableResult func indexTitles(_ closure: @escaping ((_ collectionView: UICollectionView) -> [String])) -> Self
    @discardableResult func indexTitle(_ closure: @escaping ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)) -> Self
    @discardableResult func transitionLayout(_ closure: @escaping ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)) -> Self
    @discardableResult func shouldUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)) -> Self
    @discardableResult func didUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)) -> Self
    @discardableResult func indexPathForPreferredFocusedView(_ closure: @escaping ((_ collectionView: UICollectionView) -> IndexPath?)) -> Self
    @discardableResult func targetIndexPathForMoveFromItem(_ closure: @escaping ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ toProposedIndexPath: IndexPath) -> IndexPath)) -> Self
    @discardableResult func targetContentOffset(_ closure: @escaping ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)) -> Self
}

internal protocol ConvProperty: class {
    var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)? { get set }
    var indexTitles: ((_ collectionView: UICollectionView) -> [String])? { get set }
    var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)? { get set }
    var transitionLayout: ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)? { get set }
    var shouldUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)? { get set }
    var didUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)? { get set }
    var indexPathForPreferredFocusedView: ((_ collectionView: UICollectionView) -> IndexPath?)? { get set }
    var targetIndexPathForMoveFromItem: ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)? { get set }
    var targetContentOffset: ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)? { get set }
}

public final class Conv: NSObject, ConvProperty {
    public weak var collectionView: UICollectionView?
    
    public var sections: [Section] = []
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    public override init() {
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
    public func set(scrollViewDelegate: UIScrollViewDelegate) {
        self.scrollViewDelegate = scrollViewDelegate
    }
}

extension Conv: ConvInterface {
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

public protocol C {
    
}

public protocol Diff: C {
    func diff()
}
public protocol NoDiff: C {
    func noDiff()
}

internal protocol _Diff: Diff {
    func diff()
}
internal protocol _NoDiff: NoDiff {
    func noDiff()
}

extension Conv: _Diff, Diff {
    public func diff() {
        
    }
}

extension Conv: _NoDiff, NoDiff {
    public func noDiff() {
        
    }
}

extension Conv {
    @discardableResult public func append(fileName: String = #file, functionName: String = #function, line: Int = #line, section closure: (Section) -> Void) -> Self {
        append(for: [FakeDifference(position: sections.count + 1, differenceIdentifier: "fileName: \(fileName), functionName: \(functionName), line: \(line)")]) { (_, section) in
            closure(section)
        }
        
        return self
    }
    
    @discardableResult public func append(with differenceIdentifier: DifferenceIdentifier, section closure: (Section) -> Void) -> Self {
        append(for: [FakeDifference(position: sections.count + 1, differenceIdentifier: differenceIdentifier)]) { (_, section) in
            closure(section)
        }
        
        return self
    }
    
    @discardableResult public func append<E: Differenciable>(for elements: [E], sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section(diffElement: element) { section in
                closure(element, section)
            }
        }
        
        self.sections.append(contentsOf: sections)
        return self
    }
}

