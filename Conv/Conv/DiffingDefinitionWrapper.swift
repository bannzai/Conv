//
//  DiffingDefinitionWrapper.swift
//  Conv
//
//  Created by Yudai.Hirose on 2019/03/14.
//  Copyright © 2019 廣瀬雄大. All rights reserved.
//

import Foundation

public class DiffingDefinitionWrapper {
    let collectionView: UICollectionView
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
}

extension DiffingDefinitionWrapper: DefinitionStartable {
    public func start() -> Conv {
        return startWith(conv: Conv())
    }
    
    public func startWith(conv: Conv) -> Conv {
        let mainConv = collectionView.mainConv
        let convForOverwrite = collectionView.convForOverwrite
        switch (mainConv, convForOverwrite) {
        case (nil, nil):
            collectionView.mainConv = conv
            return conv
        case _:
            collectionView.convForOverwrite = conv
            return conv
        }
    }
}

extension DiffingDefinitionWrapper: CollectionViewDiffingRelodable {
    public func update() {
        collectionView.update()
    }
}
