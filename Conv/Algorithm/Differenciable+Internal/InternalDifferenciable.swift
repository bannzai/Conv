//
//  Int+Differenciable.swift
//  Conv
//
//  Created by Yudai.Hirose on 2018/08/05.
//  Copyright © 2018年 廣瀬雄大. All rights reserved.
//

import Foundation

internal struct FakeDifference: Differenciable {
    struct Argument {
        let position: Int
        let fileName: String
        let functionName: String
        let line: Int
    }
    static func create(argument: Argument) -> FakeDifference {
        let (position, fileName, functionName, line) = (argument.position, argument.fileName, argument.functionName, argument.line)
        let identifier = """
        position: \(position),
        fileName: \(fileName),
        functionName: \(functionName),
        line: \(line)
        """
        return FakeDifference(differenceIdentifier: identifier)
    }
    let differenceIdentifier: String
    init(differenceIdentifier: DifferenceIdentifier) {
        self.differenceIdentifier = differenceIdentifier
    }
    
    func shouldUpdate(to compare: Differenciable) -> Bool {
        return false
    }
}
