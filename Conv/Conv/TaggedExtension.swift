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
extension ConvTaggedExtension: DefinitionStartable where Base: UICollectionView {
    public func start() -> Conv {
        return startWith(conv: Conv())
    }
    
    public func startWith(conv: Conv) -> Conv {
        base.mainConv = conv
        return conv
    }

    public func diffing() -> DefinitionStartable {
        return DiffingDefinitionWrapper(collectionView: base)
    }
    
    
}
