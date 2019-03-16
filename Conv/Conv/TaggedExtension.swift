//
//  TaggedExtension.swift
//  Conv
//
//  Created by Yudai.Hirose on 2019/03/14.
//  Copyright © 2019 廣瀬雄大. All rights reserved.
//

import Foundation

public struct ConvTaggedExtension<Base> {
    let base: Base
    public init (_ base: Base) {
        self.base = base
    }
}

public protocol ConvTaggedExtensionCompatible {
    associatedtype Compatible
    static var conv: ConvTaggedExtension<Compatible>.Type { get }
    var conv: ConvTaggedExtension<Compatible> { get }
}

public extension ConvTaggedExtensionCompatible {
    public static var conv: ConvTaggedExtension<Self>.Type {
        return ConvTaggedExtension<Self>.self
    }
    
    public var conv: ConvTaggedExtension<Self> {
        return ConvTaggedExtension(self)
    }
}

extension UICollectionView: ConvTaggedExtensionCompatible {}
extension ConvTaggedExtension: DefinitionStartable, CollectionViewDiffingRelodable, CollectionViewReloadable where Base: UICollectionView {
    var collectionView: UICollectionView {
        return base
    }
    
    public func start() -> Conv {
        return start(with: Conv())
    }
    
    @discardableResult public func start(with conv: Conv) -> Conv {
        collectionView.mainConv = conv
        return conv
    }

    public func diffing() -> DefinitionStartable {
        return DiffingDefinitionWrapper(collectionView: collectionView)
    }
    
    public func reload() {
        collectionView.reload()
    }
    
    public func update() {
        collectionView.update()
    }
}
