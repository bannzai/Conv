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
    internal var targetContentOffset: ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)?
    
    public func reload() {
        guard let oldConv = collectionView?.oldConv else {
            assert(collectionView?.newConv == nil)
            print(" --------- call reloaData ----------- ")
            collectionView?.reloadData()
            return
        }
        
        if let newConv = collectionView?.newConv {
            let operationSet = diffSection(from: oldConv.sections, new: newConv.sections)
            
            let itemDelete = operationSet.itemDelete.map { $0.indexPath }
            let itemInsert = operationSet.itemInsert.map { $0.indexPath }
            let itemMove = operationSet.itemMove
            let itemUpdate = operationSet.itemUpdate.map { $0.indexPath }
            
            let sectionDelete = operationSet.sectionDelete
            let sectionInsert = operationSet.sectionInsert
            let sectionMove = operationSet.sectionMove
            let sectionUpdate = operationSet.sectionUpdate

            collectionView?
                .performBatchUpdates({
                    if !itemDelete.isEmpty {
                        print(" --------- call deleteItems ----------- ")
                        print("\(itemDelete)")
                        collectionView?.deleteItems(at: itemDelete)
                    }
                    if !itemInsert.isEmpty {
                        print(" --------- call insertItems ----------- ")
                        print("\(itemInsert)")
                        collectionView?.insertItems(at: itemInsert)
                    }
                    if !itemMove.isEmpty {
                        itemMove.forEach {
                            print(" --------- call moveItem ----------- ")
                            print("source: \($0.source.indexPath), target: \($0.target.indexPath)")
                            collectionView?.moveItem(at: $0.source.indexPath, to: $0.target.indexPath)
                        }
                    }
                    if !itemUpdate.isEmpty {
                        print(" --------- call reloadItems ----------- ")
                        print("\(itemUpdate)")
                        collectionView?.reloadItems(at: itemUpdate)
                    }

                    if !sectionDelete.isEmpty {
                        print(" --------- call deleteSections ----------- ")
                        print("\(sectionDelete)")
                        collectionView?.deleteSections(IndexSet(sectionDelete))
                    }
                    if !sectionInsert.isEmpty {
                        print(" --------- call insertSections ----------- ")
                        print("\(sectionInsert)")
                        collectionView?.insertSections(IndexSet(sectionInsert))
                    }
                    if !sectionMove.isEmpty {
                        sectionMove.forEach {
                            print(" --------- call moveSection ----------- ")
                            print("source: \($0.source), target: \($0.target)")
                            collectionView?.moveSection($0.source, toSection: $0.target)
                        }
                    }
                    if !sectionUpdate.isEmpty {
                        print(" --------- call reloadSections ----------- ")
                        print("\(sectionUpdate)")
                        collectionView?.reloadSections(IndexSet(sectionUpdate))
                    }
            }, completion: nil)
        } else {
            collectionView?.reloadData()
        }
        
        collectionView?.shiftConv()
    }
}

extension Conv {
    public func didMoveItem(_ closure: @escaping ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)) {
        self.didMoveItem = closure
    }
    public func indexTitles(_ closure: @escaping ((_ collectionView: UICollectionView) -> [String])) {
        self.indexTitles = closure
    }
    public func indexTitle(_ closure: @escaping ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)) {
        self.indexTitle = closure
    }
    public func transitionLayout(_ closure: @escaping ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)) {
        self.transitionLayout = closure
    }
    public func shouldUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)) {
        self.shouldUpdateFocus = closure
    }
    public func didUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)) {
        self.didUpdateFocus = closure
    }
    public func indexPathForPreferredFocusedView(_ closure: @escaping ((_ collectionView: UICollectionView) -> IndexPath?)) {
        self.indexPathForPreferredFocusedView = closure
    }
    public func targetContentOffset(_ closure: @escaping ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)) {
        self.targetContentOffset = closure
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

