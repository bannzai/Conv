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
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
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
