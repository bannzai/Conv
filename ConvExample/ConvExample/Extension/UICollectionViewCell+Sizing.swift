//
//  UICollectionView+Sizing.swift
//  ConvExample
//
//  Created by Yudai.Hirose on 2018/09/20.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import UIKit

// MARK: - Calc Size
extension UICollectionViewCell {
    public func fittingSize(with width: CGFloat) -> CGSize {
        translatesAutoresizingMaskIntoConstraints = false
        setWidthConstatint(width)
        setNeedsLayout()
        layoutIfNeeded()
        return systemLayoutSizeFitting(UILayoutFittingCompressedSize)
    }
    
    func isWidthConstraint(_ constraint: NSLayoutConstraint) -> Bool {
        return constraint.firstItem === self &&
            constraint.firstAttribute == .width &&
            constraint.relation == .equal &&
            constraint.isActive
    }
    
    func findWidthConstraint() -> NSLayoutConstraint? {
        return constraints.filter(isWidthConstraint).first
    }
    
    public func setWidthConstatint(_ width: CGFloat) {
        if let widthConstraint = findWidthConstraint() {
            widthConstraint.isActive = false
            removeConstraint(widthConstraint)
        }
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width)
            ])
    }
}


