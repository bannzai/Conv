//
//  ListCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/07/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

class ListCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sceneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setup(with viewModel: ImageModel) {
        nameLabel.text = viewModel.imageName
        sceneImageView.image = viewModel.image
    }
}
