//
//  SectionHeaderFooterDelegate.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol SectionHeaderFooterDelegate: Reusable, SectionHeaderFooterKindable {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize?
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
}
