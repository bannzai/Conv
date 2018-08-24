//
//  ItemModel.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation
import Conv

struct ItemModel {
    let index: Int
    let imageName: String
    let image: UIImage
}

extension ItemModel: Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(index)" + imageName + "\(image.size)"
    }
}
