//
//  SectionHeaderFooter.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/07.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public enum SectionImplHeaderFooterKind: String {
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

public protocol SectionImplHeaderFooterViewable {
    var reuseIdentifier: String? { get }
    var size: CGSize? { get set }
    var kind: SectionImplHeaderFooterKind { get }
}

protocol SectionImplHeaderFooterDelegateType {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize?
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    //    func referenceSizeForHeader(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize?
    //    func referenceSizeForFooter(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize?
}

open class SectionImplHeaderFooter<View: UICollectionReusableView>: SectionImplHeaderFooterViewable {
    public typealias SectionImplHeaderFooterInformation = (headerFooter: SectionImplHeaderFooter<View>, collectionView: UICollectionView, section: Int)
    public typealias SectionImplHeaderFooterLayoutInformation = (headerFooter: SectionImplHeaderFooter<View>, collectionView: UICollectionView, layout: UICollectionViewLayout, section: Int)
    public typealias SectionImplHeaderFooterSupplymentaryView = (headerFooter: SectionImplHeaderFooter<View>, collectionView: UICollectionView,  indexPath: IndexPath)
    
    public init(kind: SectionImplHeaderFooterKind) {
        self.kind = kind
    }
    
    public init(kind: SectionImplHeaderFooterKind, closure: ((SectionImplHeaderFooter<View>) -> Void)) {
        self.kind = kind
        closure(self)
    }
    
    fileprivate var _reuseIdentifier: String?
    open var reuseIdentifier: String? {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            return nil
        }
    }
    
    open var size: CGSize?
    open let kind: SectionImplHeaderFooterKind
    
    open var configureView: ((View, SectionImplHeaderFooterInformation) -> Void)?
    open var sizeFor: ((SectionImplHeaderFooterInformation) -> CGSize?)?
    open var willDisplay: ((View, SectionImplHeaderFooterSupplymentaryView) -> Void)?
    open var didEndDisplay: ((View, SectionImplHeaderFooterSupplymentaryView) -> Void)?
}

extension SectionImplHeaderFooter: SectionImplHeaderFooterDelegateType {
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

