//
//  ImageModel.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation
import Conv

struct ImageModel {
    let index: Int
    let imageName: String
    var image: UIImage {
        return UIImage(named: imageName)!
    }
}

extension ImageModel: Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(index)" + imageName
    }
}
