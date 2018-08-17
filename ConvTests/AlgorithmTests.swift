//
//  AlgorithmTests.swift
//  ConvTests
//
//  Created by Yudai.Hirose on 2018/08/16.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import XCTest
@testable import Conv

class AlgorithmTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testInsert() {
        XCTContext.runActivity(named: "When insert only section") { (activity) in
            let sections = [make(0)]
            let items = [make(0)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let insertedSections = sections + [make(1)]
            let newConv = Conv().create(for: insertedSections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(!result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionInsert.count == 1)
        }
        
        XCTContext.runActivity(named: "When insert only item") { (activity) in
            let sections = [make(0)]
            let items = [make(0)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let insertedItems = items + [make(1)]
            let newConv = Conv().create(for: sections) { (model, section) in
                section.create(for: insertedItems, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(!result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.itemInsert.count == 1)
        }

        XCTContext.runActivity(named: "When insert section and item") { (activity) in
            let sections = [make(0)]
            let items = [make(0)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let insertedItems = items + [make(1)]
            let insertedSections = sections + [make(1)]
            let newConv = Conv().create(for: insertedSections) { (model, section) in
                section.create(for: insertedItems, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(!result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(!result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionInsert.count == 1)
            XCTAssert(result.itemInsert.count == 1)
        }
    }
    
    func testDelete() {
        XCTContext.runActivity(named: "When delete only section") { (activity) in
            var sections = [make(0), make(1)]
            let items = [make(0)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            sections.remove(at: 1)
            let newConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(!result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionDelete.count == 1)
        }
        
        XCTContext.runActivity(named: "When delete only item") { (activity) in
            let sections = [make(0)]
            var items = [make(0), make(1)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            items.remove(at: 1)
            let newConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(!result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.itemDelete.count == 1)
        }
        
        XCTContext.runActivity(named: "When delete section and item") { (activity) in
            var sections = [make(0), make(1)]
            var items = [make(0), make(1)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            sections.remove(at: 1)
            items.remove(at: 1)
            let newConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(!result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(!result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionDelete.count == 1)
            XCTAssert(result.itemDelete.count == 1)
        }
    }
    
    func testUpdate() {

        XCTContext.runActivity(named: "When update only section") { (activity) in
            let sections = [makeForUpdate(0, false), makeForUpdate(1, false)]
            let items = [makeForUpdate(0, false)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let newSections = [makeForUpdate(0, true), makeForUpdate(1, false)]
            let newConv = Conv().create(for: newSections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(!result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionUpdate.count == 1)
        }
        
        XCTContext.runActivity(named: "When update only item") { (activity) in
            let sections = [makeForUpdate(0, false)]
            let items = [makeForUpdate(0, false), makeForUpdate(1, false)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let newItems = [makeForUpdate(0, true), makeForUpdate(1, false)]
            let newConv = Conv().create(for: sections) { (model, section) in
                section.create(for: newItems, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(!result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.itemUpdate.count == 1)
        }
        
        XCTContext.runActivity(named: "When update section and item") { (activity) in
            let sections = [makeForUpdate(0, false), makeForUpdate(1, false)]
            let items = [makeForUpdate(0, false), makeForUpdate(1, false)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: items, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let newSections = [makeForUpdate(0, true), makeForUpdate(1, false)]
            let newItems = [makeForUpdate(0, true), makeForUpdate(1, false)]
            let newConv = Conv().create(for: newSections) { (model, section) in
                section.create(for: newItems, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(result.sectionInsert.isEmpty)
            XCTAssert(!result.sectionUpdate.isEmpty)
            XCTAssert(result.sectionDelete.isEmpty)
            XCTAssert(result.sectionMove.isEmpty)
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(!result.itemUpdate.isEmpty)
            XCTAssert(result.itemMove.isEmpty)
            
            XCTAssert(result.sectionUpdate.count == 1)
            XCTAssert(result.itemUpdate.count == 2)
        }
    }

    func testMove() {
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
    
    func testMixed() {
        XCTContext.runActivity(named: "When change section about delete 0, update 1, move 1 to top, inserted 2 to last") { (activity) in
            let sections = [make(0), makeForUpdate(1, false)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let newSections = [makeForUpdate(1, true), make(2)]
            let newConv = Conv().create(for: newSections) { (model, section) in
                section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(!result.sectionInsert.isEmpty)
            XCTAssert(!result.sectionUpdate.isEmpty)
            XCTAssert(!result.sectionDelete.isEmpty)
            
            // Why sectionMove is not changed?
            // Because already shifted section when before section was deleted.
            XCTAssert(result.sectionMove.isEmpty)
            
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            
            // Need move item to shifted section.
            XCTAssert(!result.itemMove.isEmpty)
            
            XCTAssert(result.sectionInsert.count == 1)
            XCTAssert(result.sectionUpdate.count == 1)
            XCTAssert(result.sectionDelete.count == 1)
            XCTAssert(result.itemMove.count == 1)
        }
        
        XCTContext.runActivity(named: "When change section about delete 0, update 1, move 1 to last, inserted 2,3 to top") { (activity) in
            let sections = [make(0), makeForUpdate(1, false)]
            let oldConv = Conv().create(for: sections) { (model, section) in
                section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let newSections = [make(2), make(3), makeForUpdate(1, true)]
            let newConv = Conv().create(for: newSections) { (model, section) in
                section.create(for: [model.id].map { make($0) }, items: { (model, item: Item<TestCollectionViewCell>) in })
            }
            
            let result = diffSection(from: oldConv.sections, new: newConv.sections)
            
            XCTAssert(!result.sectionInsert.isEmpty)
            XCTAssert(!result.sectionUpdate.isEmpty)
            XCTAssert(!result.sectionDelete.isEmpty)
            
            // Why sectionMove is not changed?
            // Because already shifted section when before section was inserted.
            XCTAssert(result.sectionMove.isEmpty)
            
            XCTAssert(result.itemInsert.isEmpty)
            XCTAssert(result.itemDelete.isEmpty)
            XCTAssert(result.itemUpdate.isEmpty)
            
            // Need move item to shifted section.
            XCTAssert(!result.itemMove.isEmpty)
            
            XCTAssert(result.sectionInsert.count == 2)
            XCTAssert(result.sectionUpdate.count == 1)
            XCTAssert(result.sectionDelete.count == 1)
            XCTAssert(result.itemMove.count == 1)
        }

    }

}

private extension AlgorithmTests {
    struct Model: Differenciable {
        let id: Int
        let isNecessaryUpdate: Bool
        
        var differenceIdentifier: DifferenceIdentifier {
            return "\(id)"
        }
        
        func shouldUpdate(to compare: Differenciable) -> Bool {
            return isNecessaryUpdate
        }
    }
    
    func make(_ id: Int) -> Model {
        return Model(id: id, isNecessaryUpdate: false)
    }
    
    func makeForUpdate(_ id: Int, _ shouldUpdate: Bool) -> Model {
        return Model(id: id, isNecessaryUpdate: shouldUpdate)
    }
}
