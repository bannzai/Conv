//
//  DetailImageCollectionViewCell.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class DetailImageCollectionViewCell: UICollectionViewCell {

    let contentImageView = UIImageView(frame: .zero)
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(contentImageView)
        
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentImageView.topAnchor.constraint(equalTo: topAnchor),
            contentImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentImageView.leftAnchor.constraint(equalTo: leftAnchor),
            contentImageView.rightAnchor.constraint(equalTo: rightAnchor),
            ]
        )
    }
}

