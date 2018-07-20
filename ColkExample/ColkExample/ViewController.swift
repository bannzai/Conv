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
    case mountain
    case river
    case forest
    
    static var elements: [SectionType] {
        return [.mountain, .river, .forest]
    }
}

struct ItemViewModel {
    let title: String
    let image: UIImage
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: "SceneryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SceneryCollectionViewCell")
        
        collectionView
            .colk()
            .create(for: SectionType.elements) { (sectionType, section) in
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: ItemImpl<SceneryCollectionViewCell>) in
                    item.configureCell = { cell, info in
                        switch sectionType {
                        case .mountain:
                            cell.backgroundColor = .red
                        case .river:
                            cell.backgroundColor = .blue
                        case .forest:
                            cell.backgroundColor = .green
                        }
                    }
                    item.size = CGSize(width: 100, height: 100)
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
            return [UInt](0..<count)
                .map { _ in ItemViewModel(title: "Stub", image: #imageLiteral(resourceName: "river")) }
        }
        switch section {
        case .mountain:
            return stub(count: 10)
        case .river:
            return stub(count: 10)
        case .forest:
            return stub(count: 10)
        }
    }
}

