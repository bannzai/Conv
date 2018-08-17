//
//  AlgorithmTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/08/16.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv

struct Model: Differenciable {
    let id: Int
    var differenceIdentifier: DifferenceIdentifier {
        return "\(id)"
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return differenceIdentifier != compare.differenceIdentifier
    }
}

class AlgorithmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testMove() {
        XCTContext.runActivity(named: "diffSection") { (activity) in
            XCTContext.runActivity(named: "When move only section") { (activity) in
                let oldConv = Conv().create(for: [0, 1, 2].map { make($0) }) { (model, section) in
                    section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                let newConv = Conv().create(for: [2, 1, 0].map { make($0) }) { (model, section) in
                    section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                
                let result = diffSection(from: oldConv.sections, new: newConv.sections)
                
                XCTAssert(result.sectionInsert.isEmpty)
                XCTAssert(result.sectionUpdate.isEmpty)
                XCTAssert(result.sectionDelete.isEmpty)
                XCTAssert(!result.sectionMove.isEmpty)
                XCTAssert(result.itemInsert.isEmpty)
                XCTAssert(result.itemDelete.isEmpty)
                XCTAssert(result.itemUpdate.isEmpty)
                XCTAssert(result.itemMove.isEmpty)

                XCTAssert(result.sectionMove.count == 2)
                
                XCTAssert(result.sectionMove[0].source == 2)
                XCTAssert(result.sectionMove[0].target == 0)
                
                XCTAssert(result.sectionMove[1].source == 0)
                XCTAssert(result.sectionMove[1].target == 2)
            }
            
            XCTContext.runActivity(named: "When only move item") { (activity) in
                let oldConv = Conv().create(for: [0].map { make($0) }) { (model, section) in
                    section.create(for: [0, 1, 2].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                let newConv = Conv().create(for: [0].map { make($0) }) { (model, section) in
                    section.create(for: [2, 1 ,0].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                
                let result = diffSection(from: oldConv.sections, new: newConv.sections)
                
                XCTAssert(result.sectionInsert.isEmpty)
                XCTAssert(result.sectionUpdate.isEmpty)
                XCTAssert(result.sectionDelete.isEmpty)
                XCTAssert(result.sectionMove.isEmpty)
                XCTAssert(result.itemInsert.isEmpty)
                XCTAssert(result.itemDelete.isEmpty)
                XCTAssert(result.itemUpdate.isEmpty)
                XCTAssert(!result.itemMove.isEmpty)
                
                XCTAssert(result.itemMove.count == 2)
            }
            
            XCTContext.runActivity(named: "When move section and item") { (activity) in
                let oldConv = Conv().create(for: [0, 1, 2].map { make($0) }) { (model, section) in
                    section.create(for: [0, 1, 2].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                let newConv = Conv().create(for: [2, 1, 0].map { make($0) }) { (model, section) in
                    section.create(for: [2, 1 ,0].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
                }
                
                let result = diffSection(from: oldConv.sections, new: newConv.sections)
                
                XCTAssert(result.sectionInsert.isEmpty)
                XCTAssert(result.sectionUpdate.isEmpty)
                XCTAssert(result.sectionDelete.isEmpty)
                XCTAssert(!result.sectionMove.isEmpty)
                XCTAssert(result.itemInsert.isEmpty)
                XCTAssert(result.itemDelete.isEmpty)
                XCTAssert(result.itemUpdate.isEmpty)
                XCTAssert(!result.itemMove.isEmpty)
                
                XCTAssert(result.sectionMove.count == 2)
                XCTAssert(result.itemMove.count == 8)
            }
        }
    }

}

private extension AlgorithmTests {
    func make(_ id: Int) -> Model {
        return Model(id: id)
    }
}
