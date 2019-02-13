//
//  SectionHeaderFooter.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/07/07.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

open class SectionHeaderFooter<View: UICollectionReusableView>: Reusable {
    public typealias SectionHeaderFooterInformation = (headerFooter: SectionHeaderFooter<View>, collectionView: UICollectionView, section: Int)
    public typealias SectionHeaderFooterLayoutInformation = (headerFooter: SectionHeaderFooter<View>, collectionView: UICollectionView, layout: UICollectionViewLayout, section: Int)
    public typealias SectionHeaderFooterSupplymentaryView = (headerFooter: SectionHeaderFooter<View>, collectionView: UICollectionView,  indexPath: IndexPath)
    
    public init(kind: SectionHeaderFooterKind) {
        self.kind = kind
    }
    
    public init(kind: SectionHeaderFooterKind, closure: ((SectionHeaderFooter<View>) -> Void)) {
        self.kind = kind
        closure(self)
    }
    
    open private(set) var reuseIdentifier: String?

    open var size: CGSize?
    public let kind: SectionHeaderFooterKind
    
    internal var configureView: ((View, SectionHeaderFooterInformation) -> Void)?
    internal var createView: ((View, SectionHeaderFooterInformation) -> Void)?
    internal var sizeFor: ((SectionHeaderFooterInformation) -> CGSize?)?
    internal var willDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
    internal var didEndDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
}

extension SectionHeaderFooter {
    public func configureView(for reuseIdentifier: String, _ closure: @escaping ((View, SectionHeaderFooterInformation) -> Void)) {
        self.reuseIdentifier = reuseIdentifier
        self.configureView = closure
    }
    public func createView(_ closure: @escaping ((View, SectionHeaderFooterInformation) -> Void)) {
        self.createView = closure
    }
    public func sizeFor(_ closure: @escaping ((SectionHeaderFooterInformation) -> CGSize)) {
        self.sizeFor = closure
    }
    public func willDisplay(_ closure: @escaping ((View, SectionHeaderFooterSupplymentaryView) -> Void)) {
        self.willDisplay = closure
    }
    public func didEndDisplay(_ closure: @escaping ((View, SectionHeaderFooterSupplymentaryView) -> Void)) {
        self.didEndDisplay = closure
    }
}
