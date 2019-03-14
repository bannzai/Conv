//
//  UICollectionViewExtensionTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/09/19.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv


class UICollectionViewExtensionTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    func testUsingOtherConv() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let closure: (Differenciable, Section) -> Void = { _, _ in }
        
        let otherConv = collectionView.conv.start().append(for: [1, 2, 3].map { make($0) }, sections: closure)
        statusCheck: do {
            XCTAssert(otherConv.sections.count == 3)
            XCTAssert(collectionView.mainConv?.sections.count == 3)
            XCTAssert(otherConv === collectionView.mainConv)
            
            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 3)
        }
        
        using: do {
            let conv = collectionView.conv.start(with: otherConv).append(for: [1, 2, 3, 4, 5].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 5)
            XCTAssert(collectionView.mainConv?.sections.count == 5)
            XCTAssert(otherConv === collectionView.mainConv)
            XCTAssert(conv === otherConv)
        }
    }
    
    func testNoOverwirteConv() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let closure: (Differenciable, Section) -> Void = { _, _ in }
        
        first: do {
            let conv = collectionView.conv.start().append(for: [1, 2, 3].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 3)
            XCTAssert(collectionView.mainConv?.sections.count == 3)
            XCTAssert(conv === collectionView.mainConv)
            
            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 3)
        }
        
        second: do {
            let conv = collectionView.conv.start().append(for: [1, 2, 3, 4, 5].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 5)
            XCTAssert(collectionView.mainConv?.sections.count == 5)
            XCTAssert(conv === collectionView.mainConv)
        }
    }
    
    func testDiffingConv() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        let closure: (Differenciable, Section) -> Void = { _, _ in }
        
        first: do {
            let conv = collectionView.conv.diffing().start().append(for: [1, 2, 3].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 3)
            XCTAssert(collectionView.mainConv?.sections.count == 3)
            XCTAssert(conv === collectionView.mainConv)

            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 3)
        }
        
        second: do {
            let conv = collectionView.conv.diffing().start().append(for: [1, 2, 3, 4, 5].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 5)
            XCTAssert(collectionView.convForOverwrite?.sections.count == 5)
            XCTAssert(conv === collectionView.convForOverwrite)

            // Not Yet update
            XCTAssert(collectionView.mainConv?.sections.count == 3)
            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 3)
        }
        
        third: do {
            let conv = collectionView.conv.diffing().start().append(for: [1, 2, 3, 4, 5, 6, 7, 8].map { make($0) }, sections: closure)
            
            XCTAssert(conv.sections.count == 8)
            XCTAssert(collectionView.convForOverwrite?.sections.count == 8)
            XCTAssert(conv === collectionView.convForOverwrite)

            // Using main conv.
            XCTAssert(collectionView.mainConv?.sections.count == 3)
            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 3)
        }
        
        shiftConv: do {
            collectionView.shiftConv()
            
            XCTAssertNil(collectionView.convForOverwrite)
            
            XCTAssert(collectionView.mainConv?.sections.count == 8)
            XCTAssert(collectionView.dataSource?.numberOfSections?(in: collectionView) == 8)
        }
    }
}
