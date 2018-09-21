//
//  Conv+Helper.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

internal extension Conv {
    func itemDelegate(indexPath: IndexPath) -> ItemDelegate? {
        return sections[indexPath.section].items[indexPath.item]
    }
    
    func headerOrFooter(for kind: SectionHeaderFooterKind, section: Int) -> SectionHeaderFooterDelegate? {
        switch kind {
        case .header:
            return sections[section].header
        case .footer:
            return sections[section].footer
        case .custom:
            return sections[section].custom
        }
    }
    
    func headerOrFooterOrNil(for kind: String, section: Int) -> SectionHeaderFooterDelegate? {
        guard let type = SectionHeaderFooterKind(kind: kind) else {
            return nil
        }
        return headerOrFooter(for: type, section: section)
    }
    
    func headerFooterViewFor(headerFooter: SectionHeaderFooterDelegate, collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionReusableView? {
        // Dequeue
        if let identifier = headerFooter.reuseIdentifier {
            let view = dequeueReusableSupplementaryView(collectionView: collectionView, kind: headerFooter.kind.kind, identifier: identifier, indexPath: indexPath)
            headerFooter.configureView(collectionView, view: view, section: indexPath.section)
            return view
        }
        
        return nil
    }
    
    func sectionHeaderFooterSizeFor(headerFooter: SectionHeaderFooterDelegate, collectionView: UICollectionView, section: Int) -> CGSize? {
        let size = headerFooter.sizeFor(collectionView, section: section)
        return size
    }
    
    func dequeueReusableSupplementaryView(collectionView: UICollectionView, kind: String, identifier: String, indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: identifier, for: indexPath)
    }
}
