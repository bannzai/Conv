//
//  Colk+Helper.swift
//  Colk
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

internal extension Colk {
    func itemDelegate(indexPath: IndexPath) -> ItemDelegatable? {
        return sections[indexPath.section].items[indexPath.item]
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
            headerFooter.configureView(collectionView, view: view, section: indexPath.section)
            return view
        }
        
        return nil
    }
    
    func sectionHeaderFooterSizeFor(headerFooter: SectionHeaderFooterDelegatable, collectionView: UICollectionView, section: Int) -> CGSize? {
        let size = headerFooter.sizeFor(collectionView, section: section)
        return size
    }
    
    func dequeueReusableSupplementaryView(collectionView: UICollectionView, kind: String, identifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}
