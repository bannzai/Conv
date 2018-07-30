//
//  SectionHeaderFooterKind.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public protocol SectionHeaderFooterKindable {
    var kind: SectionHeaderFooterKind { get }
}

public enum SectionHeaderFooterKind {
    case header
    case footer
    case custom(String)
    
    init?(kind: String) {
        switch kind {
        case UICollectionElementKindSectionHeader:
            self = .header
        case UICollectionElementKindSectionFooter:
            self = .footer
        case _:
            self = .custom(kind)
        }
    }
    
    var kind: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        case .custom(let kind):
            return kind
        }
    }
}

