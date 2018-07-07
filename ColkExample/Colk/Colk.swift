//
//  Colk.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit


public class Colk: NSObject {
    public weak var collectionView: UICollectionView?
    public var sections: [Section] = []
    public var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    public var indexTitles: ((UICollectionView) -> [String])?
    public var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    
    func itemFor(indexPath: IndexPath) -> Item {
        return sections[indexPath.section].items[indexPath.item]
    }
}

extension Colk: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = itemFor(indexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.reusableIdentifier, for: indexPath)
        (item as? ItemDelegatable)?.configureCell(collectionView: collectionView, cell: cell, indexPath: indexPath)
        return cell
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let type = SectionImplHeaderFooterKind(kind: kind) else {
            fatalError("Unknown kind: \(kind)")
        }
        switch type {
        case .header:
            if let header = sections[indexPath.section].header,
                let view = headerFooterViewFor(headerFooter: header, collectionView: collectionView, indexPath: indexPath) {
                return view
            }
        case .footer:
            if let footer = sections[indexPath.section].footer,
                let view = headerFooterViewFor(headerFooter: footer, collectionView: collectionView, indexPath: indexPath) {
                return view
            }
        }
        fatalError("")
    }
    
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        let canMoveItem = itemDelegate(indexPath: indexPath)?
            .canMoveItem(collectionView: collectionView, indexPath: indexPath)
        return canMoveItem ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item = sections[sourceIndexPath.section].remove(for: sourceIndexPath.item)
        sections[destinationIndexPath.section].insert(item, to: destinationIndexPath.item)
        didMoveItem?(sourceIndexPath, destinationIndexPath)
    }
    
    public func indexTitles(for collectionView: UICollectionView) -> [String]? {
        return indexTitles?(collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, indexPathForIndexTitle title: String, at index: Int) -> IndexPath {
        if indexTitles == nil {
            fatalError("Should implemente with self.indexTitles")
        }
        return indexTitle!(collectionView, title, index)
    }
}

extension Colk: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        let shouldHighlight = itemDelegate(indexPath: indexPath)?
            .shouldHighlight(collectionView: collectionView, indexPath: indexPath)
        return shouldHighlight ?? false
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
        return shouldSelect ?? false
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        let shouldSelect = itemDelegate(indexPath: indexPath)?
            .shouldDeselect(collectionView: collectionView, indexPath: indexPath)
        return shouldSelect ?? false
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
            let headerFooter = headerOrFooterOrNil(for: elementKind, section: indexPath.section),
            let delegate = headerFooterDelegate(headerFooter: headerFooter)
            else {
                return
        }
        delegate.willDisplay(collectionView, view: view, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        itemDelegate(indexPath: indexPath)?
            .didEndDisplay(collectionView: collectionView, cell: cell, indexPath: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        guard
            let headerFooter = headerOrFooterOrNil(for: elementKind, section: indexPath.section),
            let delegate = headerFooterDelegate(headerFooter: headerFooter)
            else {
                return
        }
        delegate.didEndDisplay(collectionView, view: view, indexPath: indexPath)
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
        fatalError("Not yet implement")
    }
    
    public func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        fatalError("Not yet implement")
    }
    
    public func collectionView(_ collectionView: UICollectionView, shouldUpdateFocusIn context: UICollectionViewFocusUpdateContext) -> Bool {
        fatalError("Not yet implement")
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
        fatalError("Not yet implement")
    }
}

extension Colk: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = itemDelegate(indexPath: indexPath)?
            .sizeFor(collectionView: collectionView, indexPath: indexPath) {
            return size
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.itemSize
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let inset = sectionDelegate(section: section)?
            .inset(collectionView: collectionView, collectionViewLayout: collectionViewLayout, section: section) {
            return inset
        }
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.sectionInset
        }
        
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let spacing = sectionDelegate(section: section)?
            .minimumLineSpacing(collectionView: collectionView, collectionViewLayout: collectionViewLayout, section: section) {
            return spacing
        }
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumLineSpacing
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let spacing = sectionDelegate(section: section)?
            .minimumInteritemSpacing(collectionView: collectionView, collectionViewLayout: collectionViewLayout, section: section) {
            return spacing
        }
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.minimumInteritemSpacing
        }
        
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let header = sections[section].header,
            let size = sectionHeaderFooterSizeFor(headerFooter: header, collectionView: collectionView, section: section) {
            return size
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        return .zero
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if let footer = sections[section].header,
            let size = sectionHeaderFooterSizeFor(headerFooter: footer, collectionView: collectionView, section: section) {
            return size
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        return .zero
    }
}

fileprivate extension Colk {
    func sectionDelegate(section: Int) -> SectionDelegatable? {
        return sectionDelegate(section: sections[section])
    }
    
    func sectionDelegate(section: Section) -> SectionDelegatable? {
        return section as? SectionDelegatable
    }
    
    func itemDelegate(indexPath: IndexPath) -> ItemDelegatable? {
        return itemDelegate(item: sections[indexPath.section].items[indexPath.item])
    }
    
    func itemDelegate(item: Item) -> ItemDelegatable? {
        return item as? ItemDelegatable
    }
    
    func headerFooterDelegate(headerFooter: SectionImplHeaderFooterViewable) -> SectionImplHeaderFooterDelegateType? {
        return headerFooter as? SectionImplHeaderFooterDelegateType
    }
    
    func headerOrFooter(for kind: SectionImplHeaderFooterKind, section: Int) -> SectionImplHeaderFooterViewable? {
        switch kind {
        case .header:
            return sections[section].header
        case .footer:
            return sections[section].footer
        }
    }
    
    func headerOrFooterOrNil(for kind: String, section: Int) -> SectionImplHeaderFooterViewable? {
        guard let type = SectionImplHeaderFooterKind(kind: kind) else {
            return nil
        }
        return headerOrFooter(for: type, section: section)
    }
    
    func headerFooterViewFor(headerFooter: SectionImplHeaderFooterViewable, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        // Dequeue
        if let identifier = headerFooter.reuseIdentifier {
            let view = dequeueReusableSupplementaryView(collectionView: collectionView, kind: headerFooter.kind.kind, identifier: identifier, indexPath: indexPath)
            if let delegate = headerFooterDelegate(headerFooter: headerFooter) {
                delegate.configureView(collectionView, view: view, section: indexPath.section)
            }
            return view
        }
        
        return nil
    }
    
    func sectionHeaderFooterSizeFor(headerFooter: SectionImplHeaderFooterViewable, collectionView: UICollectionView, section: Int) -> CGSize? {
        if let delegate = headerFooterDelegate(headerFooter: headerFooter),
            let size = delegate.sizeFor(collectionView, section: section) {
            return size
        }
        
        return headerFooter.size
    }
    
    func dequeueReusableSupplementaryView(collectionView: UICollectionView, kind: String, identifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}
