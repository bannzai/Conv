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

public enum SectionHeaderFooterKind: String {
    case header
    case footer
    
    init?(kind: String) {
        switch kind {
        case UICollectionElementKindSectionHeader:
            self = .header
        case UICollectionElementKindSectionFooter:
            self = .footer
        case _:
            return nil
        }
    }
    
    var kind: String {
        switch self {
        case .header:
            return UICollectionElementKindSectionHeader
        case .footer:
            return UICollectionElementKindSectionFooter
        }
    }
}

