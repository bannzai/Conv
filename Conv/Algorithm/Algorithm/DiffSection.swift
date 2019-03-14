//
//  DiffSection.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/18.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

func diffSection(from oldSections: [Section], new newSections: [Section]) -> OperationSet {
    let indexPathForOld = oldSections
        .enumerated()
        .flatMap { section -> [DifferenciableIndexPath] in
            section
                .element
                .items
                .enumerated()
                .map { item in
                    DifferenciableIndexPath(
                        section: section.element,
                        item: item.element,
                        sectionIndex: section.offset,
                        itemIndex: item.offset
                    )
            }
    }
    let indexPathForNew = newSections
        .enumerated()
        .flatMap { section -> [DifferenciableIndexPath] in
            section
                .element
                .items
                .enumerated()
                .map { item in
                    DifferenciableIndexPath(
                        section: section.element,
                        item: item.element,
                        sectionIndex: section.offset,
                        itemIndex: item.offset
                    )
            }
    }
    
    let sectionResult = diff(
        from: oldSections,
        to: newSections,
        mapDeleteOperation: { $0 },
        mapInsertOperation: { $0 },
        mapUpdateOperation: { $0 },
        mapMoveSourceOperation: { $0 },
        mapMoveTargetOperation: { $0 }
    )
    let sectionOperations = sectionResult.operations
    
    let movedIndexies: [(old: Int, new: Int)] = sectionOperations.compactMap {
        switch $0 {
        case .move(let old, let new):
            return (old: old, new: new)
        case _:
            return nil
        }
    }
    
    let itemOperations = diffItem(
        from: indexPathForOld,
        to: indexPathForNew,
        oldSectionReferences: sectionResult.SectionReference.old,
        newSectionReferences: sectionResult.SectionReference.new,
        movedIndexies: movedIndexies
        ).operations
    
    var operationSet = OperationSet()
    sectionOperations.forEach {
        switch $0 {
        case .insert(let newIndex):
            operationSet.sectionInsert.append(newIndex)
        case .delete(let oldIndex):
            operationSet.sectionDelete.append(oldIndex)
        case .move(let sourceIndex, let targetIndex):
            operationSet.sectionMove.append((source: sourceIndex, target: targetIndex))
        case .update(let newIndex):
            operationSet.sectionUpdate.append(newIndex)
        }
    }
    
    itemOperations.forEach {
        switch $0 {
        case .insert(let newIndex):
            operationSet.itemInsert.append(newIndex)
        case .delete(let oldIndex):
            operationSet.itemDelete.append(oldIndex)
        case .move(let sourceIndex, let targetIndex):
            operationSet.itemMove.append((source: sourceIndex, target: targetIndex))
        case .update(let newIndex):
            operationSet.itemUpdate.append(newIndex)
        }
    }
    
    return operationSet
}
