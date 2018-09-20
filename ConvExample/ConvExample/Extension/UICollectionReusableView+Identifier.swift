//
//  UICollectionViewCell+Identifier.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/09/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    public static var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
