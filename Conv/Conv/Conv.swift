//
//  Conv.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

public final class Conv: NSObject {
    public weak var collectionView: UICollectionView?
    
    public internal(set) var sections: [Section] = []
    public weak var scrollViewDelegate: UIScrollViewDelegate?
    
    public override init() {
        super.init()
    }
    
    internal var didMoveItem: ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)?
    internal var indexTitles: ((_ collectionView: UICollectionView) -> [String])?
    internal var indexTitle: ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)?
    internal var transitionLayout: ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)?
    internal var shouldUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)?
    internal var didUpdateFocus: ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)?
    internal var indexPathForPreferredFocusedView: ((_ collectionView: UICollectionView) -> IndexPath?)?
    internal var targetIndexPathForMoveFromItem: ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ proposedIndexPath: IndexPath) -> IndexPath)?
    internal var targetContentOffset: ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)?
    
}

// MARK: - Interface for mutating sections
extension Conv {
    @discardableResult public func append(sections: [Section]) -> Conv {
        self.sections.append(contentsOf: sections)
        return self
    }
}



// MARK: - Settter of UIScrollViewDelegate
extension Conv {
    public func set(scrollViewDelegate: UIScrollViewDelegate) -> Self {
        self.scrollViewDelegate = scrollViewDelegate
        return self
    }
}

// MARK: - Function for CollectionView
extension Conv {
    @discardableResult public func didMoveItem(_ closure: @escaping ((_ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)) -> Self {
        self.didMoveItem = closure
        return self
    }
    @discardableResult public func indexTitles(_ closure: @escaping ((_ collectionView: UICollectionView) -> [String])) -> Self {
        self.indexTitles = closure
        return self
    }
    @discardableResult public func indexTitle(_ closure: @escaping ((_ collectionView: UICollectionView, _ title: String, _ index: Int) -> IndexPath)) -> Self {
        self.indexTitle = closure
        return self
    }
    @discardableResult public func transitionLayout(_ closure: @escaping ((_ collectionView: UICollectionView, _ fromLayout: UICollectionViewLayout, _ toLayout: UICollectionViewLayout) -> UICollectionViewTransitionLayout)) -> Self {
        self.transitionLayout = closure
        return self
    }
    @discardableResult public func shouldUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext) -> Bool)) -> Self {
        self.shouldUpdateFocus = closure
        return self
    }
    @discardableResult public func didUpdateFocus(_ closure: @escaping ((_ collectionView: UICollectionView, _ context: UICollectionViewFocusUpdateContext, _ coordinator: UIFocusAnimationCoordinator) -> Void)) -> Self {
        self.didUpdateFocus = closure
        return self
    }
    @discardableResult public func indexPathForPreferredFocusedView(_ closure: @escaping ((_ collectionView: UICollectionView) -> IndexPath?)) -> Self {
        self.indexPathForPreferredFocusedView = closure
        return self
    }
    
    @discardableResult public func targetIndexPathForMoveFromItem(_ closure: @escaping ((_ collectionView: UICollectionView, _ originalIndexPath: IndexPath, _ toProposedIndexPath: IndexPath) -> IndexPath)) -> Self {
        self.targetIndexPathForMoveFromItem = closure
        return self
    }
    @discardableResult public func targetContentOffset(_ closure: @escaping ((_ collectionView: UICollectionView, _ proposedContentOffset: CGPoint) -> CGPoint)) -> Self {
        self.targetContentOffset = closure
        return self
    }
}

// MARK: - Delete
extension Conv {
    @discardableResult public func delete(at index: Int) -> Self {
        sections.remove(at: index)
        return self
    }
    
    @discardableResult public func delete<E: Differenciable>(for element: E) -> Self {
        sections.removeAll { (section) -> Bool in
            section.differenceIdentifier == element.differenceIdentifier
        }
        return self
    }
    
    @discardableResult public func delete<E: Differenciable>(for elements: [E]) -> Self {
        elements.forEach { delete(for: $0) }
        return self
    }
}


// MARK: - Insert
extension Conv {
    @discardableResult public func insert<E>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for element: E,
        at index: Int,
        section closure: (E, Section) -> Void
        ) -> Self {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: index,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        
        let section = Section(diffElement: fake) { (section) in
            closure(element, section)
        }
        
        self.sections.insert(section, at: index)
        return self
    }
    
    @discardableResult public func insert<E>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for elements: [E],
        at index: Int,
        sections closure: (E, Section) -> Void
        ) -> Self {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: index,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        let sections = elements.map { (element) in
            Section(diffElement: fake) { section in
                closure(element, section)
            }
        }
        
        self.sections.insert(contentsOf: sections, at: index)
        return self
    }
    
    @discardableResult public func insert<E: Differenciable>(for element: E, at index: Int, section closure: (E, Section) -> Void) -> Self {
        insert(for: [element], at: index) { (element, section) in
            closure(element, section)
        }
        
        return self
    }
    
    @discardableResult public func insert<E: Differenciable>(for elements: [E], at index: Int, sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section(diffElement: element) { section in
                closure(element, section)
            }
        }
        
        self.sections.insert(contentsOf: sections, at: index)
        return self
    }
}


// MARK: - Append
extension Conv {
    @discardableResult public func append(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        section closure: (Section) -> Void
        ) -> Self {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: sections.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        append(for: fake) { (_, section) in
            closure(section)
        }
        
        return self
    }
    
    @discardableResult public func append<E>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for element: E,
        section closure: (E, Section) -> Void
        ) -> Self {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: sections.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        let section = Section(diffElement: fake) { (section) in
            closure(element, section)
        }
        self.sections.append(section)
        return self
    }
    
    
    @discardableResult public func append<E>(
        fileName: String = #file,
        functionName: String = #function,
        line: Int = #line,
        for elements: [E],
        sections closure: (E, Section) -> Void
        ) -> Self {
        let fake = FakeDifference.create(argument: FakeDifference.Argument(
            position: self.sections.count,
            fileName: fileName,
            functionName: functionName,
            line: line
        ))
        let sections = elements.map { (element) in
            Section(diffElement: fake) { section in
                closure(element, section)
            }
        }
        self.sections.append(contentsOf: sections)
        return self
    }


    @discardableResult public func append<E: Differenciable>(for element: E, section closure: (E, Section) -> Void) -> Self {
        append(for: [element]) { (element, item) in
            closure(element, item)
        }
        return self
    }
    
    @discardableResult public func append<E: Differenciable>(for elements: [E], sections closure: (E, Section) -> Void) -> Self {
        let sections = elements.map { (element) in
            Section(diffElement: element) { section in
                closure(element, section)
            }
        }
        
        self.sections.append(contentsOf: sections)
        return self
    }
}

