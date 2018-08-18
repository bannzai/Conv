//
//  EmoticoinCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/09.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class EmoticoinCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var iconLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(text: String) {
        iconLabel.text = text
    }

}
