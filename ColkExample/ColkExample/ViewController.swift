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
}

class ViewController: UIViewController {
    
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
                        view.backgroundColor = .red
                    }
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 100)
                })
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: ItemImpl<ImageCollectionViewCell>) in
                    item.reusableIdentifier = "ImageCollectionViewCell"
                    item.configureCell { (cell, info) in
                        cell.setup(with: viewModel)
                    }
                    
                    let gridCount: CGFloat = 3
                    item.size = CGSize(width: floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount), height: 200)
                })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }
}

extension ViewController {
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

