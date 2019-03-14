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
    typealias ProfileCell = ProfileHeaderCollectionViewCell
    typealias SectionHeader = ProfileSectionHeaderCollectionReusableView
    typealias ImageCell = ListCollectionViewCell
    
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
            
            collectionView.register(UINib(nibName: ProfileCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProfileCell.identifier)
            collectionView.register(UINib(nibName: SectionHeader.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
            collectionView.register(UINib(nibName: ImageCell.identifier, bundle: nil), forCellWithReuseIdentifier: ImageCell.identifier)
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
        collectionView.conv.reload()
    }
    
    func setup(me: User, images: [ImageModel]) {
        collectionView
            .conv.start()
            .create { (section) in
                section.create{ (item: Item<ProfileCell>) in
                    item.sizeFor { (item, collectionView, indexPath) in
                        return ProfileCell.size(with: collectionView.bounds.width, user: me)
                    }
                    item.configureCell(for: ProfileCell.identifier) { (cell, itemInfo) in
                        cell.configure(user: me)
                    }
                }
            }
            .create { (section) in
                section.append(.header) { (header: SectionHeaderFooter<SectionHeader>) in
                    header.sizeFor { (item, collectionView, indexPath) in
                        return CGSize(width: collectionView.bounds.width, height: 44)
                    }
                    header.configureView(for: SectionHeader.identifier, { (header, headerInfo) in
                        header.titleLabel.text = "My Photos"
                    })
                }
                section.append(for: images) { (viewModel, item: Item<ImageCell>) in
                    item.sizeFor({ _ -> CGSize in
                        let gridCount: CGFloat = 3
                        let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                        let size = CGSize(width: edge, height: edge)
                        return size
                    })
                    item.configureCell(for: ImageCell.identifier) { (cell, info) in
                        cell.setup(with: viewModel)
                    }
                    item.didSelect { [weak self] (item) in
                        let viewController = DetailViewController(imageName: viewModel.imageName)
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                }
        }
    }
}

