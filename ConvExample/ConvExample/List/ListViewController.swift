//
//  ViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv


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
    ]
    
    var sectionTypes: [SectionType] = SectionType.firstElements
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "List"
        
        collectionView.register(UINib(nibName: "ListCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListCollectionViewCell")
        collectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderReusableView")

        collectionView.contentInset.bottom = 40
        
        flowLayout?.sectionInset = .zero
        flowLayout?.minimumLineSpacing = 0
        flowLayout?.minimumInteritemSpacing = 0
    }
    
    func setupConv() {
        collectionView
            .conv()
            .create(for: sectionTypes) { (sectionType, section) in
                // In closure passed each element from variable for sectionTypes and configuration for section.
                
                // Section has creating section header or footer method.
                // `create header or footer` method to use generics and convert automaticary each datasource and delegate method.(e.g SectionHeaderFooter<ListCollectionReusableView>)
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<SectionHeaderReusableView>) in
                    
                    // Setting each property and wrapped datasource or delegate method
                    header.reusableIdentifier = "ListCollectionReusableView"
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView { view, _ in
                        // `view` was converted to ListCollectionReusableView
                        
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = sectionType.backgroundColor
                    }
                })
                
                // Section has creating items for count of elements.
                // `create item` method to use generics type and convert automaticary to each datasource and delegate method. (e.g Item<ListCollectionViewCell>)
                let itemModels = imageNames
                    .enumerated()
                    .map { ItemModel(index: $0.0, imageName: $0.1) }
                
                section.create(for: itemModels, items: { (viewModel, item: Item<ListCollectionViewCell>) in
                    // In closure passed each element from variable of itemModels and configuration for item.
                    
                    // Setting each property and wrapped datasource or delegate method
                    item.reusableIdentifier = "ListCollectionViewCell"
                    item.sizeFor({ _ -> CGSize in
                        let gridCount: CGFloat = 3
                        let edge = floor((UIScreen.main.bounds.width - (gridCount - 1)) / gridCount)
                        let size = CGSize(width: edge, height: edge)
                        return size
                    })
                    
                    item.configureCell { (cell, info) in
                        
                        // cell was converted to ListCollectionViewCell
                        cell.setup(with: viewModel)
                    }
                    
                    item.didSelect { [weak self] (item) in
                        let viewController = DetailViewController(imageName: viewModel.imageName)
                        self?.navigationController?.pushViewController(viewController, animated: true)
                    }
                })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupConv()
        collectionView.reload()

        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItemButtonPressed(button:))),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSectionButtonPressed(button:))),
            UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonPressed(button:)))
        ]
    }
    
    @objc func addItemButtonPressed(button: UIBarButtonItem) {
        imageNames.append(contentsOf: imageNames)
        reload()
    }
    
    @objc func addSectionButtonPressed(button: UIBarButtonItem) {
        sectionTypes = SectionType.append(contents: sectionTypes)
        reload()
    }
    
    @objc func refreshButtonPressed(button: UIBarButtonItem) {
        imageNames = [
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
        
        sectionTypes = SectionType.firstElements
        
        reload()
    }
    
    func reload() {
        setupConv()
        collectionView.reload()
    }
    
    deinit {
        print("For \(#file), \(#function) called")
    }
}
