//
//  ProfileHeaderCollectionViewCell.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/09/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var profileImageBackgroundView: UIView!
    @IBOutlet weak var profileIconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var sendStarButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImageBackgroundView.layer.borderColor = UIColor.white.cgColor
        profileImageBackgroundView.layer.borderWidth = 1
        profileImageBackgroundView.layer.cornerRadius = 60
    }
    
    func configure(user: User) {
        profileIconImageView.image = user.profileImage
        nameLabel.text = user.name
        introductionLabel.text = user.introduction
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://github.com/bannzai/conv")!, options: [:], completionHandler: nil)
    }
    
    static let cellForCalcSize: ProfileHeaderCollectionViewCell = UINib(nibName: "ProfileHeaderCollectionViewCell", bundle: nil)
        .instantiate(withOwner: nil, options: nil)
        .first! as! ProfileHeaderCollectionViewCell
    
    static func size(with width: CGFloat, user: User) -> CGSize {
        cellForCalcSize.configure(user: user)
        let size = cellForCalcSize.fittingSize(with: width)
        return size
    }
}
