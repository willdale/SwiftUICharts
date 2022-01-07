//
//  Bar.swift
//  
//
//  Created by Will Dale on 06/01/2022.
//

import Foundation
import CoreGraphics

public func barYAxisPOIMarkerX<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ height: T) -> T {
   return height - divideByZeroProtection(T.self, (value - min), range) * height
}

public func barXAxisPOIMarkerX<T: BinaryInteger, U: BinaryFloatingPoint>(_ value: T, _ count: T, _ width: U) -> U {
    // same as lineXAxisPOIMarkerX
    return divideByZeroProtection(U.self, width, U(count - 1)) * U(value)
}

public func horizontalBarYPosition<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ width: T) -> T {
    return divideByZeroProtection(T.self, (value - min), range) * width
}

public func horizontalBarXAxisPOIMarkerY<T: BinaryInteger, U: BinaryFloatingPoint>(_ value: T, _ count: T, _ height: U) -> U {
    return divideByZeroProtection(U.self, height, U(count)) * U(value) + ((height / U(count)) / 2)
}
