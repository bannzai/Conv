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

}

extension SectionTests: Stub { }
