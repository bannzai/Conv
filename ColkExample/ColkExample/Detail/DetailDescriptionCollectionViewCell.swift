//
//  DetailDescriptionCollectionViewCell.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

class DetailDescriptionCollectionViewCell: UICollectionViewCell {

    let descriptionLabel = UILabel(frame: .zero)
    
    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(descriptionLabel)
        
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = .white
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8),
            descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 16),
            ]
        )
    }
}
