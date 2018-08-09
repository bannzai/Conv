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

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sectionModels: [SectionModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shuffle"
        
        reset()

        collectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderReusableView")
        collectionView.register(UINib(nibName: "EmoticoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmoticoinCollectionViewCell")
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
        let columns: CGFloat = 12
        let cellWidth = floor((UIScreen.main.bounds.width - (columns - 1)) / columns)
        collectionView
            .conv()
            .create(for: sectionModels) { (sectionModel, section) in
                let sectionType = sectionModel.sectionType
                
                section.create(.header, headerOrFooter: { (header: SectionHeaderFooter<SectionHeaderReusableView>) in
                    header.reusableIdentifier = "SectionHeaderReusableView"
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView { view, _ in
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = .black
                    }
                })
                
                let backgroundColor: UIColor
                switch sectionType {
                case .one:
                    backgroundColor = UIColor.green.withAlphaComponent(0.2)
                case .two:
                    backgroundColor = UIColor.orange.withAlphaComponent(0.2)
                case .three:
                    backgroundColor = UIColor.purple.withAlphaComponent(0.2)
                case .four:
                    backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
                }
                
                let emoticons = sectionModels[sectionType.rawValue].emoticons
                section.create(for: emoticons, items: { (emoticon, item: Item<EmoticoinCollectionViewCell>) in
                    item.reusableIdentifier = "EmoticoinCollectionViewCell"
                    item.size = CGSize(width: cellWidth, height: cellWidth)
                    item.configureCell({ (cell, info) in
                        cell.configure(text: emoticon)
                    })
                    item.willDisplay({ (cell, info) in
                        cell.backgroundColor = backgroundColor
                    })
                })
            }
    }
    
    func reload() {
        setupConv()
        collectionView.reload()
    }
    
    func shuffleAllEmoticions() {
        var flattenEmoticons = sectionModels.flatMap { $0.emoticons }.shuffled()
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
        sectionModels = sectionModels.shuffled()
        reload()
    }
    
    func reset() {
        let emoticons: [String] = (0x1F600...0x1F647).compactMap { UnicodeScalar($0).map(String.init) }
        sectionModels = SectionType.elements.map { return SectionModel(sectionType: $0, emoticons: emoticons) }
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
