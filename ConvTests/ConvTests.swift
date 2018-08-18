//
//  ConvTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv

class ConvTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateSection() {
        XCTContext.runActivity(named: "create section") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.create { (section) in return }
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "create two sections") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.create(for: [make(0), make(1)], sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
        }
    }
    
    func testDidMoveItem() {
        let conv = Conv()
        
        var called = false
        
        conv.didMoveItem { (sourceIndexPath, destinationIndexPath) in
            called = true
        }
        
        conv.didMoveItem?(indexPath(), indexPath())
        
        XCTAssertTrue(called)
    }
    
    func testIndexTitles() {
        let conv = Conv()
        
        let titles: [String] = ["1", "2"]

        conv.indexTitles { (collectionView) -> [String] in
            return titles
        }

        let result = conv.indexTitles?(collectionView())
        
        XCTAssert(result == titles)
    }
    
    func testIndexTitle() {
        let conv = Conv()
        
        let titles: [String] = ["1", "2"]
        let indexPathOfTitle = IndexPath(item: 1, section: 0)
        
        // Should implement for indexTitle
        conv.indexTitles { (collectionView) -> [String] in
            return titles
        }
        
        conv.indexTitle { (collectionView, title, index) -> IndexPath in
            return indexPathOfTitle
        }
        
        let result = conv.indexTitle?(collectionView(), titles[0], 0)
        
        XCTAssert(result == indexPathOfTitle)
    }
    
    func testTransitionLayout() {
        let conv = Conv()
        
        let currentLayout = UICollectionViewLayout()
        let nextLayout = UICollectionViewLayout()

        conv.transitionLayout { (collectionView, fromLayout, toLayout) -> UICollectionViewTransitionLayout in
            return UICollectionViewTransitionLayout(currentLayout: currentLayout, nextLayout: nextLayout)
        }
        
        let result = conv.transitionLayout?(collectionView(), UICollectionViewLayout(), UICollectionViewLayout())
        
        XCTAssert(result?.currentLayout === currentLayout)
        XCTAssert(result?.nextLayout === nextLayout)
    }
    
//    func testShouldUpdateFocus() {
//        let conv = Conv()
//
//        conv.shouldUpdateFocus { (collectionView, context) -> Bool in
//            return true
//        }
//
//        let context: UICollectionViewFocusUpdateContext = UICollectionViewFocusUpdateContext()
//        let result = conv.shouldUpdateFocus?(collectionView(), context)
//
//        XCTAssertTrue(result!)
//    }
    
    func testIndexPathForPreferredFocusedView() {
        let conv = Conv()
        
        let indexPath = self.indexPath()

        conv.indexPathForPreferredFocusedView { (collectionView) -> IndexPath? in
            return indexPath
        }
        
        let result = conv.indexPathForPreferredFocusedView?(collectionView())
        
        XCTAssertEqual(result, indexPath)
    }
    
    func testTargetIndexPathForMoveFromItem() {
        let conv = Conv()
        
        let indexPath = self.indexPath()
        
        conv.targetIndexPathForMoveFromItem { (collectionView, originalIndexPath, proposedIndexPath) -> IndexPath in
            return indexPath
        }

        let result = conv.targetIndexPathForMoveFromItem?(collectionView(), self.indexPath(), self.indexPath())
        
        XCTAssertEqual(result, indexPath)
    }
    
    func testTargetContentOffset() {
        let conv = Conv()
        
        let offset = CGPoint(x: 1, y: 1)
        conv.targetContentOffset { (collectionView, propsosedContentOffset) -> CGPoint in
            return propsosedContentOffset
        }

        let result = conv.targetContentOffset?(collectionView(), offset)
        
        XCTAssertEqual(result, offset)
    }
}

extension ConvTests: Stub { }
