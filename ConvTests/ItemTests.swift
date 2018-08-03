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
        let item = Item<TestCollectionViewCell>()
        
        item.sizeFor { (info) in
            return CGSize(width: 100, height: 100)
        }
        
        let size = item.sizeFor(collectionView: collectionView(), indexPath: indexPath())
        
        XCTAssertEqual(size, CGSize(width: 100, height: 100))
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
}
