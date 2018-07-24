//
//  DetailViewController.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/07/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Colk

public class DetailViewController: UIViewController {
    private let imageName: String
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    public init(imageName: String) {
        self.imageName = imageName
        
        super.init(nibName: nil, bundle: nil)
    }

    
    public override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ]
        )
        
        let imageName = self.imageName
        collectionView
            .colk()
            .create { (section) in
                section
                    .create(item: { (item: ItemImpl<DetailImageCollectionViewCell>) in
                        item.configureCell { (cell, info) in
                            cell.contentImageView.image = UIImage(named: imageName)
                        }
                    })
            }
            .create { (section) in
                section.create { (item: ItemImpl<DetailDescriptionCollectionViewCell>) in
                    item.configureCell { (cell, info) in
                        cell.descriptionLabel.text = """
                        Your should send star request for this repository.
                        ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
                        So, I'm glad. I'm happy.
                        My name bannzai.
                        Nice to meet you
                        """
                    }
                }
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.reloadData()
    }
}
