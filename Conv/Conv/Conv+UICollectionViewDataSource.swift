//
//  Conv+UICollectionView.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

extension Conv: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = sections[indexPath.section].items[indexPath.item]
        if let reuseIdentifier = item.reuseIdentifier {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            item.configureCell(collectionView: collectionView, cell: cell, indexPath: indexPath)
            return cell
        }
        
        fatalError("Not yet register cell")
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let type = SectionHeaderFooterKind(kind: kind) else {
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
        case .custom(_):
            if let custom = sections[indexPath.section].custom,
                let view = headerFooterViewFor(headerFooter: custom, collectionView: collectionView, indexPath: indexPath) {
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
        let item = sections[sourceIndexPath.section].remove(at: sourceIndexPath.item)
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
