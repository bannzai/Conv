//
//  DetailViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/07/24.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

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
        
        setupCollectionView: do {
            collectionView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                ]
            )
            
            collectionView.register(DetailImageCollectionViewCell.self, forCellWithReuseIdentifier: "DetailImageCollectionViewCell")
            collectionView.register(DetailDescriptionCollectionViewCell.self, forCellWithReuseIdentifier: "DetailDescriptionCollectionViewCell")
        }
        
        createConv: do {
            let imageName = self.imageName
            collectionView
                .conv(scrollViewDelegate: self)
                .append(with: "Section 0") { (section) in
                    section
                        .append(with: "Item in Section 0", item: { (item: Item<DetailImageCollectionViewCell>) in
                            let image = UIImage(named: imageName)!
                            item.configureCell(for: "DetailImageCollectionViewCell") { (cell, info) in
                                cell.contentImageView.image = image
                            }
                            item.sizeFor() { (info) -> CGSize in
                                let ratio = UIScreen.main.bounds.height / UIScreen.main.bounds.width
                                let height = image.size.width / ratio
                                return CGSize(width: UIScreen.main.bounds.width, height: height)
                            }
                        })
                }
                .append(with: "Section 1") { (section) in
                    section.append(with: "Item in Section 1") { (item: Item<DetailDescriptionCollectionViewCell>) in
                        item.configureCell(for: "DetailDescriptionCollectionViewCell") { (cell, info) in
                            cell.descriptionLabel.text = """
                            Hi, I'm bannzai.
                            bannzai means \\(^o^)/.
                            Nice to meet you.
                            If you love this library, you should send start request to this repository.
                            ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
                            So, I'm glad. I'm happy!!
                            """
                        }
                        item.size = CGSize(width: UIScreen.main.bounds.width, height: 200)
                    }
            }
        }

        title = imageName
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView.conv.update()
    }
}

extension DetailViewController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("scrollView: \(scrollView)")
    }
}
