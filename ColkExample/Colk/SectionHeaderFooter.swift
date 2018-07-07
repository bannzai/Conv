//
//  SectionHeaderFooter.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/07.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public enum CollectionViewSectionHeaderFooterKind: String {
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

public protocol CollectionViewSectionHeaderFooterViewable {
    var reuseIdentifier: String? { get }
    var size: CGSize? { get set }
    var kind: CollectionViewSectionHeaderFooterKind { get }
}

protocol CollectionViewSectionHeaderFooterDelegateType {
    func configureView(_ collectionView: UICollectionView, view: UICollectionReusableView, section: Int)
    func sizeFor(_ collectionView: UICollectionView, section: Int) -> CGSize?
    func willDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    func didEndDisplay(_ collectionView: UICollectionView, view: UICollectionReusableView, indexPath: IndexPath)
    //    func referenceSizeForHeader(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize?
    //    func referenceSizeForFooter(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize?
}

open class CollectionViewSectionHeaderFooter<View: UICollectionReusableView>: CollectionViewSectionHeaderFooterViewable {
    public typealias CollectionViewSectionHeaderFooterInformation = (headerFooter: CollectionViewSectionHeaderFooter<View>, collectionView: UICollectionView, section: Int)
    public typealias CollectionViewSectionHeaderFooterLayoutInformation = (headerFooter: CollectionViewSectionHeaderFooter<View>, collectionView: UICollectionView, layout: UICollectionViewLayout, section: Int)
    public typealias CollectionViewSectionHeaderFooterSupplymentaryView = (headerFooter: CollectionViewSectionHeaderFooter<View>, collectionView: UICollectionView,  indexPath: IndexPath)
    
    public init(kind: CollectionViewSectionHeaderFooterKind) {
        self.kind = kind
    }
    
    public init(kind: CollectionViewSectionHeaderFooterKind, closure: ((CollectionViewSectionHeaderFooter<View>) -> Void)) {
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
    open let kind: CollectionViewSectionHeaderFooterKind
    
    open var configureView: ((View, CollectionViewSectionHeaderFooterInformation) -> Void)?
    open var sizeFor: ((CollectionViewSectionHeaderFooterInformation) -> CGSize?)?
    open var willDisplay: ((View, CollectionViewSectionHeaderFooterSupplymentaryView) -> Void)?
    open var didEndDisplay: ((View, CollectionViewSectionHeaderFooterSupplymentaryView) -> Void)?
    //    open var referenceSizeForHeader: ((CollectionViewSectionHeaderFooterLayoutInformation) -> CGSize?)?
    //    open var referenceSizeForFooter: ((CollectionViewSectionHeaderFooterLayoutInformation) -> CGSize?)?
}

extension CollectionViewSectionHeaderFooter: CollectionViewSectionHeaderFooterDelegateType {
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
    
    //    func referenceSizeForHeader(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize? {
    //        return referenceSizeForHeader?((self, collectionView, collectionViewLayout, section)) ?? size
    //    }
    //    func referenceSizeForFooter(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize? {
    //        return referenceSizeForHeader?((self, collectionView, collectionViewLayout, section)) ?? size
    //    }
    //    func reusableViewFor(collectionView: UICollectionView, supplementaryOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    //
    //    }
}

