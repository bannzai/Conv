//
//  ListSectionType.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation
import Conv

enum SectionType: Int {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    static var firstElements: [SectionType] {
        return [.one, .two, .three]
    }
    
    static func append(contents: [SectionType]) -> [SectionType] {
        guard
            let last = contents.last,
            let next = SectionType(rawValue: last.rawValue + 1)
            else {
                return contents
        }
        
        return contents + [next]
    }
    
    
    var backgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
    }
}

extension SectionType: Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(self)"
    }
}
