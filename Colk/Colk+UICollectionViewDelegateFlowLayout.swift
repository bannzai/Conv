//
//  Colk+UICollectionViewDelegateFlowLayout.swift
//  Colk
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

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
        if let footer = sections[section].footer,
            let size = sectionHeaderFooterSizeFor(headerFooter: footer, collectionView: collectionView, section: section) {
            return size
        }
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            return layout.headerReferenceSize
        }
        return .zero
    }
}

