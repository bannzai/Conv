//
//  ProfileHeaderCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/09/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var sendStarButton: UIButton!
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
    }
}
