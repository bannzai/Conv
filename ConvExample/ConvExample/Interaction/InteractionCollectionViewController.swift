//
//  InteractionCollectionViewController.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/08/09.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Conv

public class InteractionCollectionViewController: UIViewController {
    enum SectionType: Int, Differenciable {
        case one
        case two
        case three
        
        static var elements: [SectionType] {
            return [.one, .two, .three]
        }
        
        var differenceIdentifier: DifferenceIdentifier {
            return "\(self)"
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var emoticons = (0x1F600...0x1F647).compactMap { UnicodeScalar($0).map(String.init) }
    lazy var emoticonsForEachSection = SectionType.elements.map { _ in
        return self.emoticons
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMoveCellGesture()
        
        collectionView.register(UINib(nibName: "SectionHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionHeaderReusableView")
        collectionView.register(UINib(nibName: "EmoticoinCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmoticoinCollectionViewCell")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reload()
    }
    
    func setupMoveCellGesture() {
        collectionView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(gesture:))))
    }
    
    @objc func handleLongPressGesture(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: gesture.view)) else {
                return
            }
            
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
        case .ended:
            collectionView.endInteractiveMovement()
        case .cancelled:
            collectionView.cancelInteractiveMovement()
        case .possible:
            return
        case .failed:
            return
        }
    }
    
    func setupConv() {
        let columns: CGFloat = 4
        let cellWidth = floor((UIScreen.main.bounds.width - (columns - 1)) / columns)
        collectionView
            .conv.start()
            .append(for: SectionType.elements) { (sectionType, section) in
                section.append(.header, headerOrFooter: { (header: SectionHeaderFooter<SectionHeaderReusableView>) in
                    header.size = CGSize(width: UIScreen.main.bounds.width, height: 50)
                    header.configureView(for: "SectionHeaderReusableView") { view, _ in
                        view.nameLabel.text = "\(sectionType)".uppercased()
                        view.nameLabel.textColor = .white
                        view.backgroundColor = .black
                    }
                })
                
                let backgroundColor: UIColor
                switch sectionType {
                case .one:
                    backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
                case .two:
                    backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
                case .three:
                    backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
                }
                
                let emoticons = emoticonsForEachSection[sectionType.rawValue]
                section.append(for: emoticons, items: { (emoticon, item: Item<EmoticoinCollectionViewCell>) in
                    item.size = CGSize(width: cellWidth, height: cellWidth)
                    item.configureCell(for: "EmoticoinCollectionViewCell", { (cell, info) in
                        cell.configure(text: emoticon)
                    })
                    item.willDisplay({ (cell, info) in
                        cell.backgroundColor = backgroundColor
                    })
                    item.canMoveItem({ (info) -> Bool in
                        return true
                    })
                })
            }
            .didMoveItem { [weak self] (sourceIndexPath, destinationIndexPath) in
                guard let `self` = self else {
                    return
                }
                let emoticon = self.emoticonsForEachSection[sourceIndexPath.section].remove(at: sourceIndexPath.item)
                self.emoticonsForEachSection[destinationIndexPath.section].insert(emoticon, at: destinationIndexPath.item)
                self.reload()
            }
            .targetIndexPathForMoveFromItem { (collectionView, originalIndexPath, proposedIndexPath) -> IndexPath in
                if originalIndexPath.section != proposedIndexPath.section {
                    return originalIndexPath
                }

                return proposedIndexPath
        }
    }
    
    func reload() {
        setupConv()
        collectionView.update()
    }
}
