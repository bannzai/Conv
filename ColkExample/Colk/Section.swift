//
//  Section.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public protocol Section {
    var items: [ItemType] { get set }
}

public struct SectionImpl: Section {
    public var items: [ItemType]
}
