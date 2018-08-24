//
//  SectionTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/08/03.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv

class SectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCreateItem() {
        XCTContext.runActivity(named: "create item") { (activity) in
            let section = Section()
            XCTAssert(section.items.count == 0)
            section.create(with: "Item") { (_) in return }
            XCTAssert(section.items.count == 1)
        }
        XCTContext.runActivity(named: "create two items") { (activity) in
            let section = Section()
            XCTAssert(section.items.count == 0)
            section.create(for: [make(0), make(1)], items: { (_, _) in return })
            XCTAssert(section.items.count == 2)
        }
    }
    
    func sectionInset() {
        let section = Section()

        let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        section.inset { args in
            return inset
        }
        
        let collectionView = self.collectionView()
        XCTAssertEqual(
            section.inset(collectionView: collectionView, collectionViewLayout: collectionView.collectionViewLayout, section: 0),
            inset
        )
    }

    func sectionMinimumLineSpacing() {
        let section = Section()
        
        section.minimumLineSpacing { args in
            return 10
        }
        
        let collectionView = self.collectionView()
        XCTAssertEqual(
            section.minimumLineSpacing(collectionView: collectionView, collectionViewLayout: collectionView.collectionViewLayout, section: 0),
            10
        )
    }

    func sectionMinimumInteritemSpacing() {
        let section = Section()
        
        section.minimumLineSpacing { args in
            return 10
        }
        
        let collectionView = self.collectionView()
        XCTAssertEqual(
            section.minimumInteritemSpacing(collectionView: collectionView, collectionViewLayout: collectionView.collectionViewLayout, section: 0),
            10
        )
    }
}

extension SectionTests: Stub { }
