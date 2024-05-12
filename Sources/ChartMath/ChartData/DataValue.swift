//
//  DataValue.swift
//  
//
//  Created by Will Dale on 12/05/2024.
//

import Foundation

public protocol SingleDataValue {
    var value: Double { get }
}


public protocol RangedDataValue {
//    var value: Double { get }
    var upperValue: Double { get }
    var lowerValue: Double { get }
}
