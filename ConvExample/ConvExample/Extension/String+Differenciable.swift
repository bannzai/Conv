//
//  String+Differenciable.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/10.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation
import Conv

extension String: Differenciable {
    public var differenceIdentifier: DifferenceIdentifier {
        return self
    }
}

