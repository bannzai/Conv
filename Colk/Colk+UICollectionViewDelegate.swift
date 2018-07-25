//
//  Colk+UICollectionViewDelegate.swift
//  Colk
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

extension Colk: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let shouldHighlight = itemDelegate(indexPath: indexPath)?
            .shouldHighlight(collectionView: collectionView, indexPath: indexPath)
        return shouldHighlight ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didHighlight(collectionView: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didUnhighlight(collectionView: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let shouldSelect = itemDelegate(indexPath: indexPath)?
            .shouldSelect(collectionView: collectionView, indexPath: indexPath)
        return shouldSelect ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let shouldSelect = itemDelegate(indexPath: indexPath)?
            .shouldDeselect(collectionView: collectionView, indexPath: indexPath)
        return shouldSelect ?? true
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didSelect(collectionView: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didDeselect(collectionView: collectionView, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .willDisplay(collectionView: collectionView, cell: cell, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard
            let headerFooter = headerOrFooterOrNil(for: elementKind, section: indexPath.section)
            else {
                return
        }
        headerFooter.willDisplay(collectionView, view: view, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didEndDisplay(collectionView: collectionView, cell: cell, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard
            let headerFooter = headerOrFooterOrNil(for: elementKind, section: indexPath.section)
            else {
                return
        }
        
        headerFooter.didEndDisplay(collectionView, view: view, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        let shouldShowMenu = itemDelegate(indexPath: indexPath)?
            .shouldShowMenu(collectionView: collectionView, indexPath: indexPath)
        return shouldShowMenu ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        let canPerformAction = itemDelegate(indexPath: indexPath)?
            .canPerformAction(collectionView: collectionView, action: action, forItemAt: indexPath, withSender: sender)
        return canPerformAction ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        itemDelegate(indexPath: indexPath)?
            .performAction(collectionView: collectionView, action: action, forItemAt: indexPath, withSender: sender)
    }
    
    public func collectionView(_ collectionView: UICollectionView, transitionLayoutForOldLayout fromLayout: UICollectionViewLayout, newLayout toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout {
        return transitionLayout?(collectionView, fromLayout, toLayout) ??
            UICollectionViewTransitionLayout(currentLayout: fromLayout, nextLayout: toLayout)
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return itemDelegate(indexPath: indexPath)?
            .canFocusItem(collectionView: collectionView, indexPath: indexPath) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        return shouldUpdateFocus?(collectionView, context) ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        fatalError("Not yet implement")
    }
    
    public func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        fatalError("Not yet implement")
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, targetIndexPathForMoveFromItemAt originalIndexPath: IndexPath, toProposedIndexPath proposedIndexPath: IndexPath) -> IndexPath {
        fatalError("Not yet implement")
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, targetContentOffsetForProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        fatalError("Not yet implement")
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, shouldSpringLoadItemAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        return itemDelegate(indexPath: indexPath)?
            .shouldSpringLoadItem(collectionView: collectionView, indexPath: indexPath, context: context) ?? true
    }
}
