//
//  ListCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

struct ItemViewModel: ReflectionDifferenciable {
    let index: Int
    let imageName: String
    let image: UIImage
}

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sceneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: ItemViewModel) {
        nameLabel.text = viewModel.imageName
        sceneImageView.image = viewModel.image
    }
}
