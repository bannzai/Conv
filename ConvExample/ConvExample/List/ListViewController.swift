//
//  ViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

enum SectionType: Int, Differenciable {
    var differenceIdentifier: DifferenceIdentifier {
        return "\(self)"
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return differenceIdentifier != compare.differenceIdentifier
    }
    
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    static var firstElements: [SectionType] {
        return [.one, .two, .three]
    }
    
    static func append(contents: [SectionType]) -> [SectionType] {
        guard
            let last = contents.last,
            let next = SectionType(rawValue: last.rawValue + 1)
            else {
            return contents
        }
        
        return contents + [next]
    }
    
    
    var backgroundColor: UIColor {
        return UIColor.black.withAlphaComponent(0.3)
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
    ]
    
    var elements: [SectionType] = SectionType.firstElements
    
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
            
            // Create sections for count of elements.
            .create(for: elements) { (sectionType, section) in
                // In closure passed each element from elements and configuration for section.
                
                // Section has creating section header or footer method.
                // `create header or footer` method to use generics and convert automaticary each datasource and delegate method.(e.g SectionHeaderFooter<SectionHeaderReusableView>)
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<SectionHeaderReusableView>) in
                    
                    // Setting each property and wrapped datasource or delegate method
                    header.reusableIdentifier = "SectionHeaderReusableView"
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView { view, _ in
                        // `view` was converted to SectionHeaderReusableView
                        
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = sectionType.backgroundColor
                    }
                })
                
                // Section has creating items for count of elements.
                // `create item` method to use generics type and convert automaticary to each datasource and delegate method. (e.g Item<ListCollectionViewCell>)
                section.create(for: viewModels(section: sectionType), items: { (viewModel, item: Item<ListCollectionViewCell>) in
                    // In closure passed each element from elements and configuration for section.
                    
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
        elements = SectionType.append(contents: elements)
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
        
        elements = SectionType.firstElements
        
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

extension ListViewController {
    func viewModels(section: SectionType) -> [ItemViewModel] {
        func stub() -> [ItemViewModel] {
            return imageNames
                .enumerated()
                .map { ItemViewModel(index: $0.0, imageName: $0.1, image: UIImage(named: $0.1)!) }
        }
        
        return stub()
    }
}

