//
//  MenuViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/09.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

enum MenuType: Int, Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(self)"
    }

    case list
    case move
    case shuffle
    case profile
    
    var title: String {
        switch self {
        case .list:
            return "Add section or item, and delete it"
        case .move:
            return "Moving interactive collection view cell"
        case .shuffle:
            return "Shuffle section and items"
        case .profile:
            return "Example like profile screen"
        }
    }
    
    static var elements: [MenuType] {
        return [.list, .move, .shuffle, .profile]
    }
}

public class MenuViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "\\(^o^)/"
        
        collectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func setupConv() {
        collectionView
            .conv()
            .append(with: "Section 0") { (section) in
                section
                    .append(for: MenuType.elements, items: { (menuType, item: Item<MenuCollectionViewCell>) in
                        item.configureCell(for: "MenuCollectionViewCell", { (cell, info) in
                            cell.setup(title: menuType.title)
                        })
                        item.size = CGSize(width: UIScreen.main.bounds.width, height: 44)
                        item.didSelect({ [weak self] (info) in
                            switch menuType {
                            case .list:
                                let storyboard = UIStoryboard(name: "ListViewController", bundle: nil)
                                let viewController = storyboard.instantiateInitialViewController()!
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            case .move:
                                let storyboard = UIStoryboard(name: "InteractionCollectionViewController", bundle: nil)
                                let viewController = storyboard.instantiateInitialViewController()!
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            case .shuffle:
                                let viewController = ShuffleViewController()
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            case .profile:
                                let viewController = ProfileViewController()
                                self?.navigationController?.pushViewController(viewController, animated: true)
                            }
                        })
                    }
                )
        }
    }
    
    func reload() {
        setupConv()
        collectionView.update()
    }
}
