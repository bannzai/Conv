//
//  Colk+Helper.swift
//  Colk
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

internal extension Colk {
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
    
    func headerFooterDelegate(headerFooter: SectionHeaderFooterView) -> SectionHeaderFooterDelegatable? {
        return headerFooter as? SectionHeaderFooterDelegatable
    }
    
    func headerOrFooter(for kind: SectionHeaderFooterKind, section: Int) -> SectionHeaderFooterView? {
        switch kind {
        case .header:
            return sections[section].header
        case .footer:
            return sections[section].footer
        }
    }
    
    func headerOrFooterOrNil(for kind: String, section: Int) -> SectionHeaderFooterView? {
        guard let type = SectionHeaderFooterKind(kind: kind) else {
            return nil
        }
        return headerOrFooter(for: type, section: section)
    }
    
    func headerFooterViewFor(headerFooter: SectionHeaderFooterView, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        // Dequeue
        if let identifier = headerFooter.reusableIdentifier {
            let view = dequeueReusableSupplementaryView(collectionView: collectionView, kind: headerFooter.kind.kind, identifier: identifier, indexPath: indexPath)
            if let delegate = headerFooterDelegate(headerFooter: headerFooter) {
                delegate.configureView(collectionView, view: view, section: indexPath.section)
            }
            return view
        }
        
        return nil
    }
    
    func sectionHeaderFooterSizeFor(headerFooter: SectionHeaderFooterView, collectionView: UICollectionView, section: Int) -> CGSize? {
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
