//
//  ShuffleViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/10.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

class ShuffleViewController: UIViewController {
    enum SectionType: Int {
        case one
        case two
        case three
        case four
        
        static var elements: [SectionType] {
            return [.one, .two, .three, .four]
        }
        
    }
    
    struct SectionModel: Differenciable {
        let sectionType: SectionType
        let emoticons: [String]

        var differenceIdentifier: DifferenceIdentifier {
            return "\(sectionType)"
        }
    }

    private let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    
    var sectionModels: [SectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            ]
        )
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 1
            flowLayout.minimumInteritemSpacing = 1
        }
        
        title = "Shuffle"
        
        collectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderReusableView")
        collectionView.register(UINib(nibName: "EmoticoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmoticoinCollectionViewCell")
        
        reset()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Emoticons", style: .plain, target: self, action: #selector(shuffleAllEmoticionsButtonPressed(button:))),
            UIBarButtonItem(title: "Section", style: .plain, target: self, action: #selector(shuffleSectionButtonPressed(button:))),
            UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(resetOrderButtonPressed(button:))),
        ]
    }
    
    
    func setupConv() {
        let columns: CGFloat = 4
        let cellWidth = floor((UIScreen.main.bounds.width - (columns - 1)) / columns)
        collectionView
            .conv()
            .create(for: sectionModels) { (sectionModel, section) in
                let sectionType = sectionModel.sectionType
                
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<SectionHeaderReusableView>) in
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView(for: "SectionHeaderReusableView") { view, _ in
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = UIColor.black.withAlphaComponent(0.1)
                    }
                })
                
                let emoticons = sectionModel.emoticons
                section.create(for: emoticons, items: { (emoticon, item: Item<EmoticoinCollectionViewCell>) in
                    item.size = CGSize(width: cellWidth, height: cellWidth)
                    item.configureCell(for: "EmoticoinCollectionViewCell", { (cell, info) in
                        cell.configure(text: emoticon)
                    })
                    item.willDisplay({ (cell, info) in
                        cell.backgroundColor = .white
                    })
                })
            }
    }
    
    func reload() {
        setupConv()
        collectionView.update()
    }
    
    func shuffleAllEmoticions() {
        var flattenEmoticons = sectionModels
            .flatMap { $0.emoticons }
            .shuffled()
        
        sectionModels = sectionModels
            .map {
                let count = $0.emoticons.count
                let emoticons = Array(flattenEmoticons.prefix(count))
                flattenEmoticons.removeFirst(count)
                return SectionModel(sectionType: $0.sectionType, emoticons: emoticons)
    }
        
        reload()
    }
    
    func shuffleSection() {
        let section = sectionModels.removeFirst()
        sectionModels.append(section)
        reload()
    }
    
    func reset() {
        let start = 0x1F600
        let column = 16
        sectionModels = SectionType.elements.enumerated().map { offset, sectionType in
            let start = start + offset * column
            let end = start + (column - 1)
            let emoticons: [String] = (start...end).compactMap { UnicodeScalar($0).map(String.init) }
            return SectionModel(sectionType: sectionType, emoticons: emoticons)
        }
        reload()
    }
}

private extension ShuffleViewController {
    @objc func shuffleAllEmoticionsButtonPressed(button: UIBarButtonItem) {
        shuffleAllEmoticions()
    }
    
    @objc func shuffleSectionButtonPressed(button: UIBarButtonItem) {
        shuffleSection()
    }
    
    @objc func resetOrderButtonPressed(button: UIBarButtonItem) {
        reset()
    }
}

private extension Sequence {
    func shuffled() -> [Element] {
        var result = ContiguousArray(self)
        result.shuffle()
        return Array(result)
    }
}

private extension MutableCollection where Self : RandomAccessCollection {
    mutating func shuffle() {
        var amount = count
        var currentIndex = startIndex
        
        while amount > 1 {
            let random = Int(arc4random_uniform(UInt32(amount)))
            
            swapAt(
                currentIndex,
                index(currentIndex, offsetBy: numericCast(random))
            )
            formIndex(after: &currentIndex)
            
            amount -= 1
        }
    }
}
