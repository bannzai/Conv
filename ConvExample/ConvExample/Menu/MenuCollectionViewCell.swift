//
//  MenuCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/09.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = ""
        backgroundColor = UIColor.groupTableViewBackground.withAlphaComponent(0.4)
    }
    
    func setup(title: String) {
        titleLabel.text = title
    }
}
