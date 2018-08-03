//
//  ItemTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/07/31.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv

class TestCollectionViewCell: UICollectionViewCell {
    
}

class ItemTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testConfigureCell() {
        let item = Item<TestCollectionViewCell>()
        var called = false

        item.configureCell { (cell, info) in
            called = true
        }
        
        XCTAssertFalse(called)
        item.configureCell(collectionView: collectionView(), cell: cell(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testSizeFor() {
        let closureSize = CGSize(width: 100, height: 100)
        let propertySize = CGSize(width: 50, height: 50)
        
        XCTContext.runActivity(named: "When configure return size") { _ in
            let create: () -> Item<TestCollectionViewCell> = {
                let item = Item<TestCollectionViewCell>()
                item.sizeFor { (info) in
                    return closureSize
                }
                return item
            }

            XCTContext.runActivity(named: "and setting propertySize to item.size then return closureSize") { _ in
                let item = create()
                item.size = propertySize
                let size = item.sizeFor(collectionView: collectionView(), indexPath: indexPath())
                XCTAssertEqual(size, closureSize)
            }
            
            XCTContext.runActivity(named: "and not setting size property then return closureSize") { _ in
                let item = create()
                let size = item.sizeFor(collectionView: collectionView(), indexPath: indexPath())
                XCTAssertEqual(size, closureSize)
            }
        }
        
        XCTContext.runActivity(named: "When not configure return size") { _ in
            let create: () -> Item<TestCollectionViewCell> = {
                let item = Item<TestCollectionViewCell>()
                //            item.sizeFor { (info) in
                //                return closureSize
                //            }
                return item
            }

            XCTContext.runActivity(named: "and setting propertySize to item.size then return propertySize") { _ in
                let item = create()
                item.size = propertySize
                let size = item.sizeFor(collectionView: collectionView(), indexPath: indexPath())
                XCTAssertEqual(size, propertySize)
            }
            
            XCTContext.runActivity(named: "and not setting size property then return nil") { _ in
                let item = create()
                let size = item.sizeFor(collectionView: collectionView(), indexPath: indexPath())
                XCTAssertNil(size)
            }
        }
    }
    
    func testCanMove() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canMoveItem { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.canMoveItem(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canMoveItem { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.canMoveItem(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }
    
    func testWillDisplay() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.willDisplay { (cell, info) in
            called = true
        }
        
        XCTAssertFalse(called)
        item.willDisplay(collectionView: collectionView(), cell: cell(), indexPath: indexPath())
        XCTAssertTrue(called)
    }

    func testDidEndDisplay() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.didEndDisplay { (cell, info) in
            called = true
        }
        
        XCTAssertFalse(called)
        item.didEndDisplay(collectionView: collectionView(), cell: cell(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testShouldHighlight() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldHighlight { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.shouldHighlight(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldHighlight { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.shouldHighlight(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }
    
    func testDidHighlight() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.didHighlight { info in
            called = true
        }
        
        XCTAssertFalse(called)
        item.didHighlight(collectionView: collectionView(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testDidUnhighlight() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.didUnhighlight { info in
            called = true
        }
        
        XCTAssertFalse(called)
        item.didUnhighlight(collectionView: collectionView(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testShouldSelect() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldSelect { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.shouldSelect(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldSelect { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.shouldSelect(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }
    
    func testShouldDeselect() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldDeselect { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.shouldDeselect(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldDeselect { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.shouldDeselect(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }
    
    func testDidSelect() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.didSelect { info in
            called = true
        }
        
        XCTAssertFalse(called)
        item.didSelect(collectionView: collectionView(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testDidDeselect() {
        let item = Item<TestCollectionViewCell>()
        var called = false
        
        item.didDeselect { info in
            called = true
        }
        
        XCTAssertFalse(called)
        item.didDeselect(collectionView: collectionView(), indexPath: indexPath())
        XCTAssertTrue(called)
    }
    
    func testShouldShowMenu() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldShowMenu { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.shouldShowMenu(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.shouldShowMenu { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.shouldShowMenu(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }

    func testCanPerformAction() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canPerformAction { (item) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.canPerformAction(collectionView: self.collectionView(), action: #selector(selector), forItemAt: indexPath(), withSender: self)!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canPerformAction { (item) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.canPerformAction(collectionView: self.collectionView(), action: #selector(selector), forItemAt: indexPath(), withSender: self)!)
        }
    }
    
    func testCanFocusItem() {
        XCTContext.runActivity(named: "When configure return true") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canFocusItem { (info) -> Bool in
                return true
            }
            
            XCTAssertTrue(item.canFocusItem(collectionView: collectionView(), indexPath: indexPath())!)
        }
        
        XCTContext.runActivity(named: "When configure return false") { _ in
            let item = Item<TestCollectionViewCell>()
            item.canFocusItem { (info) -> Bool in
                return false
            }
            
            XCTAssertFalse(item.canFocusItem(collectionView: collectionView(), indexPath: indexPath())!)
        }
    }
    
    func testTargetIndexPathForMoveFromItem() {
        let item = Item<TestCollectionViewCell>()
        let testIndexPath = IndexPath(item: 1, section: 2)
            
        item.targetIndexPathForMoveFromItem { (item, collectionView, originalIndexPath, proposedIndexPath) in
            return testIndexPath
        }
        
        let movedIndexPath = item.targetIndexPathForMoveFromItem(collectionView: collectionView(), originalIndexPath: indexPath(), proposedIndexPath: indexPath())
        XCTAssertEqual(movedIndexPath, testIndexPath)
    }
}

private extension ItemTests {
    func collectionView() -> UICollectionView {
        // Necessary collectionViewLayout
        return UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    func cell() -> TestCollectionViewCell {
        return TestCollectionViewCell()
    }
    
    func indexPath() -> IndexPath {
        return IndexPath()
    }
    
    @objc func selector() {
        
    }
}
