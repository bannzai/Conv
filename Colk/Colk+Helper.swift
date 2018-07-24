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
        return sections[indexPath.section].items[indexPath.item]
    }
    
    func headerFooterDelegate(headerFooter: SectionHeaderFooterDelegatable) -> SectionHeaderFooterDelegatable? {
        return headerFooter as? SectionHeaderFooterDelegatable
    }
    
    func headerOrFooter(for kind: SectionHeaderFooterKind, section: Int) -> SectionHeaderFooterDelegatable? {
        switch kind {
        case .header:
            return sections[section].header
        case .footer:
            return sections[section].footer
        }
    }
    
    func headerOrFooterOrNil(for kind: String, section: Int) -> SectionHeaderFooterDelegatable? {
        guard let type = SectionHeaderFooterKind(kind: kind) else {
            return nil
        }
        return headerOrFooter(for: type, section: section)
    }
    
    func headerFooterViewFor(headerFooter: SectionHeaderFooterDelegatable, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
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
    
    func sectionHeaderFooterSizeFor(headerFooter: SectionHeaderFooterDelegatable, collectionView: UICollectionView, section: Int) -> CGSize? {
        if let delegate = headerFooterDelegate(headerFooter: headerFooter),
            let size = delegate.sizeFor(collectionView, section: section) {
            return size
        }
        
        return nil
    }
    
    func dequeueReusableSupplementaryView(collectionView: UICollectionView, kind: String, identifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}
