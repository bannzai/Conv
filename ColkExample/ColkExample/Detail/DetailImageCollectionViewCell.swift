//
//  DetailImageCollectionViewCell.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class DetailImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let contentImageSize = contentImageView.image?.size else {
            return .zero
        }
        
        let ratio = contentImageSize.width / UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height * ratio
        return CGSize(width: contentImageSize.width , height: height)
    }
}
