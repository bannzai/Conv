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

public protocol SectionHeaderFooterView: Reusable {
    var size: CGSize? { get set }
    var kind: SectionHeaderFooterKind { get }
}

protocol SectionHeaderFooterDelegateType {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize?
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
}

open class SectionHeaderFooter<View: UICollectionReusableView>: SectionHeaderFooterView {
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
    
    private var _reusableIdentifier: String?
    open var reusableIdentifier: String {
        get {
            if let identifier = _reusableIdentifier {
                return identifier
            }
            return View.className
        }
        set {
            _reusableIdentifier = newValue
        }
    }
    
    open var size: CGSize?
    open let kind: SectionHeaderFooterKind
    
    open var configureView: ((View, SectionHeaderFooterInformation) -> Void)?
    open var sizeFor: ((SectionHeaderFooterInformation) -> CGSize?)?
    open var willDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
    open var didEndDisplay: ((View, SectionHeaderFooterSupplymentaryView) -> Void)?
}

extension SectionHeaderFooter: SectionHeaderFooterDelegateType {
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

