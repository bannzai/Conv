//
//  ReflectionDifferenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/09.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

public protocol ReflectionDifferenciable: Differenciable {
    
}

extension ReflectionDifferenciable {
    public var differenceIdentifier: DifferenceIdentifier {
        let mirror = Mirror(reflecting: self)
        let subjectType = "\(mirror.subjectType)"
        let propertiesValue = mirror
            .children
            .reduce("", { (result, child)  in
                guard let label = child.label else {
                    return result
                }
                
                let value: String
                let metatype = type(of: child.value)
                switch metatype {
                case is AnyClass:
                    value = "\(Unmanaged.passUnretained(child.value as AnyObject).toOpaque())"
                case _:
                    value = "\(child.value)"
                }
                
                
                let merged = "\(label): \(value)"
                switch result.isEmpty {
                case true:
                    return result + merged
                case false:
                    return ", " + result + merged
                }
            })
        
        print("value: \(subjectType + propertiesValue)")
        return subjectType + propertiesValue
    }
}
