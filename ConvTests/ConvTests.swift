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
    
    func testDeleteSection() {
        XCTContext.runActivity(named: "delete at index") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: [make(0), make(1)], at: 0, sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
            conv.delete(at: 0)
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "delete with identifier") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: make(0), at: 0, section: { (_, _) in return })
            XCTAssert(conv.sections.count == 1)
            conv.delete(for: make(0))
            XCTAssert(conv.sections.count == 0)
        }
        XCTContext.runActivity(named: "delete elements") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: [make(0), make(1)], at: 0, sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
            conv.delete(for: [make(0), make(1)])
            XCTAssert(conv.sections.count == 0)
        }
    }
    
    func testInsertSection() {
        XCTContext.runActivity(named: "insert no Differenciable section") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: (), at: 0) { (e, section) in return }
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "insert no Differenciable  sections") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: [(), ()], at: 0, sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
        }
        XCTContext.runActivity(named: "insert Differenciable section") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: make(0), at: 0) { (_, _) in return }
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "insert Differenciable two sections") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.insert(for: [make(0), make(1)], at: 0, sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
        }
    }
    
    func testAppendSection() {
        XCTContext.runActivity(named: "append no Differenciable section") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.append(for: ()) { (e, section) in return }
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "append no Differenciable two sections") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.append(for: [(), ()], sections: { (element, section) in return })
            XCTAssert(conv.sections.count == 2)
        }
        XCTContext.runActivity(named: "append Differenciable section") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.append(for: make(0)) { (e, section) in return }
            XCTAssert(conv.sections.count == 1)
        }
        XCTContext.runActivity(named: "append Differenciable two sections") { (activity) in
            let conv = Conv()
            XCTAssert(conv.sections.count == 0)
            conv.append(for: [make(0), make(1)], sections: { (element, section) in return })
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
