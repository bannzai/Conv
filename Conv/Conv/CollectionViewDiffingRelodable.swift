//
//  CollectionViewDiffingRelodable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2019/03/14.
//  Copyright © 2019 廣瀬雄大. All rights reserved.
//

import Foundation

protocol CollectionViewDiffingRelodable {
    func update()
}

internal protocol _CollectionViewDiffingRelodable: CollectionViewDiffingRelodable {
    func update()
}
