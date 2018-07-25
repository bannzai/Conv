//
//  NSObjectExtension.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

internal extension NSObject {
    static var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
