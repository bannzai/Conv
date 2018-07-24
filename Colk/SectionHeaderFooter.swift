//
//  SectionHeaderFooter.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/07.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public enum SectionHeaderFooterKind: String {
    case header
    case footer
    
    init?(kind: String) {
        switch kind {
        case UICollectionElementKindSectionHeader:
            self = .header
        case UICollectionElementKindSectionFooter:
            self = .footer
        case _:
            return nil
        }
    }
    
    var kind: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}

protocol SectionHeaderFooterDelegatable: Reusable {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize?
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
}

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
    
    open var reusableIdentifier: String?

    open var size: CGSize?
    open let kind: SectionHeaderFooterKind
    
    internal var configureView: ((View, SectionHeaderFooterInformation) -> Void)?
    internal var createView: ((View, SectionHeaderFooterInformation) -> Void)?
    internal var sizeFor: ((SectionHeaderFooterInformation) -> CGSize?)?
    internal var willDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
    internal var didEndDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
}

extension SectionHeaderFooter {
    public func configureView(_ closure: @escaping ((View, SectionHeaderFooterInformation) -> Void)) {
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

extension SectionHeaderFooter: SectionHeaderFooterDelegatable {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int) {
        guard let view = view as? View else {
            fatalError()
        }
        configureView?(view, (self, collectionView, section))
    }
    
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize? {
        return sizeFor?((self, collectionView, section)) ?? size
    }
    
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath) {
        guard let view = view as? View else {
            fatalError()
        }
        willDisplay?(view, (self, collectionView, indexPath))
    }
    
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath) {
        guard let view = view as? View else {
            fatalError()
        }
        didEndDisplay?(view, (self, collectionView, indexPath))
    }
}

