//
//  ViewController.swift
//  ColkExample
//
//  Created by Yudai.Hirose on 2018/04/25.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit
import Colk

fileprivate enum SectionType {
    case mountain
    case see
    case forest
    
    static var elements: [SectionType] {
        return [.mountain, .see, .forest]
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.colk().create(for: SectionType.elements) { (sectionType, section) in
        }
    }
}

