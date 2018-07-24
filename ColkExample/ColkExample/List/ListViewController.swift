//
//  ViewController.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Colk

enum SectionType {
    case one
    case two
    case three
    
    static var elements: [SectionType] {
        return [.one, .two, .three]
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .one:
            return UIColor.black.withAlphaComponent(0.8)
        case .two:
            return UIColor.black.withAlphaComponent(0.6)
        case .three:
            return UIColor.black.withAlphaComponent(0.45)
        }
    }
}

class ListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
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
        "xbox",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.register(UINib(nibName: "CategoryCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CategoryCollectionReusableView")
        
        flowLayout?.sectionInset = .zero
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0

        collectionView
            .colk()
            .create(for: SectionType.elements) { (sectionType, section) in
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<CategoryCollectionReusableView>) in
                    header.reusableIdentifier = "CategoryCollectionReusableView"
                    header.configureView { view, _ in
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = sectionType.backgroundColor
                    }
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                })
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: ItemImpl<ImageCollectionViewCell>) in
                    item.reusableIdentifier = "ImageCollectionViewCell"
                    item.configureCell { (cell, info) in
                        cell.setup(with: viewModel)
                    }
                    
                    item.didSelect { (item) in
                        print("item: \(item)")
                    }
                    
                    let gridCount: CGFloat = 3
                    let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                    item.size = CGSize(width: edge, height: edge)
                })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension ListViewController {
    func viewModels(section: SectionType) -> [ItemViewModel] {
        func stub(count: UInt) -> [ItemViewModel] {
            return imageNames
                .map { ItemViewModel(title: $0, image: UIImage(named: $0)!) }
        }
        switch section {
        case .one:
            return stub(count: 10)
        case .two:
            return stub(count: 10)
        case .three:
            return stub(count: 10)
        }
    }
}

