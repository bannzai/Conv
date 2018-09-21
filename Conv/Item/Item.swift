//
//  Item.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public class Item<Cell: UICollectionViewCell>: Reusable {
    public typealias ItemArgument = (item: Item<Cell>, collectionView: UICollectionView, indexPath: IndexPath)
    public typealias PerformActionArgument = (item: Item<Cell>, collectionView: UICollectionView, action: Selector, indexPath: IndexPath, sender: Any?)
    
    public private(set) var reuseIdentifier: String?
    public var diffElement: Differenciable!

    public var size: CGSize?
    
    internal var configureCell: ((Cell, ItemArgument) -> Void)?
    internal var sizeFor: ((ItemArgument) -> CGSize)?
    
    internal var canMoveItem: ((ItemArgument) -> Bool)?
    
    internal var willDisplay: ((Cell, ItemArgument) -> Void)?
    internal var didEndDisplay: ((Cell, ItemArgument) -> Void)?
    
    internal var shouldHighlight: ((ItemArgument) -> Bool)?
    internal var didHighlight: ((ItemArgument) -> Void)?
    internal var didUnhighlight: ((ItemArgument) -> Void)?
    
    internal var shouldSelect: ((ItemArgument) -> Bool)?
    internal var shouldDeselect: ((ItemArgument) -> Bool)?
    internal var didSelect: ((ItemArgument) -> Void)?
    internal var didDeselect: ((ItemArgument) -> Void)?
    
    internal var shouldShowMenu: ((ItemArgument) -> Bool)?
    internal var canPerformAction: ((PerformActionArgument) -> Bool)?
    internal var performAction: ((PerformActionArgument) -> Void)?
    
    internal var canFocusItem: ((ItemArgument) -> Bool)?
    
    init() {
        
    }

    public init(diffElement: Differenciable, closure: (Item) -> Void) {
        self.diffElement = diffElement
        closure(self)
    }
}

extension Item {
    public func configureCell(for reuseIdentifier: String, _ closure: @escaping ((Cell, ItemArgument) -> Void)) {
        self.reuseIdentifier = reuseIdentifier
        self.configureCell = closure
    }
    public func sizeFor(_ closure: @escaping ((ItemArgument) -> CGSize)) {
        self.sizeFor = closure
    }
    
    public func canMoveItem(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.canMoveItem = closure
    }
    
    public func willDisplay(_ closure: @escaping ((Cell, ItemArgument) -> Void)) {
        self.willDisplay = closure
    }
    public func didEndDisplay(_ closure: @escaping ((Cell, ItemArgument) -> Void)) {
        self.didEndDisplay = closure
    }
    
    public func shouldHighlight(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.shouldHighlight = closure
    }
    public func didHighlight(_ closure: @escaping ((ItemArgument) -> Void)) {
        self.didHighlight = closure
    }
    public func didUnhighlight(_ closure: @escaping ((ItemArgument) -> Void)) {
        self.didUnhighlight = closure
    }
    
    public func shouldSelect(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.shouldSelect = closure
    }
    public func shouldDeselect(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.shouldDeselect = closure
    }
    public func didSelect(_ closure: @escaping ((ItemArgument) -> Void)) {
        self.didSelect = closure
    }
    public func didDeselect(_ closure: @escaping ((ItemArgument) -> Void)) {
        self.didDeselect = closure
    }
    
    public func shouldShowMenu(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.shouldShowMenu = closure
    }
    public func canPerformAction(_ closure: @escaping ((PerformActionArgument) -> Bool)) {
        self.canPerformAction = closure
    }
    public func performAction(_ closure: @escaping ((PerformActionArgument) -> Void)) {
        self.performAction = closure
    }
    public func canFocusItem(_ closure: @escaping ((ItemArgument) -> Bool)) {
        self.canFocusItem = closure
    }
}
