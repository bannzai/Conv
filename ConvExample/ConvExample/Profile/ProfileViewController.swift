//
//  ProfileViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/09/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

public class ProfileViewController: UIViewController {
    private let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    

    let me: User = .init()
    var imageNames: [String] = [
        "forest",
        "moon",
        "mountain",
        "pond",
        "river",
        "road",
        "snow",
        "volcano",
        "water_fall",
        ]
    

    public override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        
        view.addSubview(collectionView)
        
        setupCollectionView: do {
            collectionView.backgroundColor = UIColor(red: 22 / 255, green: 32 / 255, blue: 42 / 255, alpha: 1)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                ]
            )
            
            collectionView.register(UINib(nibName: "ProfileHeaderCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileHeaderCollectionViewCell")
            collectionView.register(UINib(nibName: "ProfileSectionHeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "ProfileSectionHeaderCollectionReusableView")
            collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        }
        
        flowLayout?.sectionInset = .zero
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
        
        title = "Profile"
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup(
            me: me,
            images: imageNames
                .enumerated()
                .map { ImageModel(index: $0.0, imageName: $0.1) }
        )
        collectionView.reload()
    }
    
    func setup(me: User, images: [ImageModel]) {
        collectionView
            .conv()
            .create { (section) in
                section.create(item: { (item: Item<ProfileHeaderCollectionViewCell>) in
                    item.reusableIdentifier = "ProfileHeaderCollectionViewCell"
                    item.sizeFor { (item, collectionView, indexPath) in
                        return ProfileHeaderCollectionViewCell.size(with: collectionView.bounds.width, user: me)
                    }
                    item.configureCell({ (cell, itemInfo) in
                        cell.configure(user: me)
                    })
                })
            }
            .create { (section) in
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<ProfileSectionHeaderCollectionReusableView>) in
                    header.reusableIdentifier = "ProfileSectionHeaderCollectionReusableView"
                    header.sizeFor { (item, collectionView, indexPath) in
                        return CGSize(width: collectionView.bounds.width, height: 44)
                    }
                    header.configureView({ (header, headerInfo) in
                        header.titleLabel.text = "My Photos"
                    })
                })
                
                section.create(for: images, items: { (viewModel, item: Item<ListCollectionViewCell>) in
                    item.reusableIdentifier = "ListCollectionViewCell"
                    item.sizeFor({ _ -> CGSize in
                        let gridCount: CGFloat = 3
                        let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                        let size = CGSize(width: edge, height: edge)
                        return size
                    })
                    item.configureCell { (cell, info) in
                        cell.setup(with: viewModel)
                    }
                    item.didSelect { [weak self] (item) in
                        let viewController = DetailViewController(imageName: viewModel.imageName)
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                })
        }
    }
}

