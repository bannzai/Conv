//
//  Item.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public protocol ItemDelegatable {
    func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize?
    
    func canMoveItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    
    func willDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    func didEndDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath)
    
    func shouldHighlight(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func didHighlight(collectionView: UICollectionView, indexPath: IndexPath)
    func didUnhighlight(collectionView: UICollectionView, indexPath: IndexPath)
    
    func shouldSelect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func shouldDeselect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func didSelect(collectionView: UICollectionView, indexPath: IndexPath)
    func didDeselect(collectionView: UICollectionView, indexPath: IndexPath)
    
    func shouldShowMenu(collectionView: UICollectionView, indexPath: IndexPath) -> Bool?
    func canPerformAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool?
    func performAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?)
}

public class Item<Cell: UICollectionViewCell>: Reusable {
    public typealias ItemArgument = (item: Item<Cell>, collectionView: UICollectionView, indexPath: IndexPath)
    public typealias PerformActionArgument = (item: Item<Cell>, collectionView: UICollectionView, action: Selector, indexPath: IndexPath, sender: Any?)
    
    public var reusableIdentifier: String?

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
    
    public init(closure: (Item) -> Void) {
        closure(self)
    }
}

extension Item {
    public func configureCell(_ closure: @escaping ((Cell, ItemArgument) -> Void)) {
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
}

extension Item: ItemDelegatable {
    public func configureCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        configureCell?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func sizeFor(collectionView: UICollectionView, indexPath: IndexPath) -> CGSize? {
        return sizeFor?((self, collectionView, indexPath)) ?? size
    }
    
    public func canMoveItem(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return canMoveItem?((self, collectionView, indexPath))
    }
    
    public func willDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        willDisplay?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func didEndDisplay(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: IndexPath) {
        didEndDisplay?(cell as! Cell, (self, collectionView, indexPath))
    }
    
    public func shouldHighlight(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldHighlight?((self, collectionView, indexPath))
    }
    
    public func didHighlight(collectionView: UICollectionView, indexPath: IndexPath) {
        didHighlight?((self, collectionView, indexPath))
    }
    
    public func didUnhighlight(collectionView: UICollectionView, indexPath: IndexPath) {
        didUnhighlight?((self, collectionView, indexPath))
    }
    
    public func shouldSelect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldSelect?((self, collectionView, indexPath))
    }
    
    public func shouldDeselect(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldDeselect?((self, collectionView, indexPath))
    }
    
    public func didSelect(collectionView: UICollectionView, indexPath: IndexPath) {
        didSelect?((self, collectionView, indexPath))
    }
    
    public func didDeselect(collectionView: UICollectionView, indexPath: IndexPath) {
        didDeselect?((self, collectionView, indexPath))
    }
    
    public func shouldShowMenu(collectionView: UICollectionView, indexPath: IndexPath) -> Bool? {
        return shouldShowMenu?((self, collectionView, indexPath))
    }
    
    public func canPerformAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool? {
        return canPerformAction?((self, collectionView, action, indexPath, sender))
    }
    
    public func performAction(collectionView: UICollectionView, action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        performAction?((self, collectionView, action, indexPath, sender))
    }
}
