//
//  Section.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public protocol SectionType {
    var items: [ItemType] { get set }
}

public struct Section: SectionType {
    public var items: [ItemType]
}

