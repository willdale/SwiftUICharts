//
//  Bar.swift
//  
//
//  Created by Will Dale on 06/01/2022.
//

import Foundation
import CoreGraphics

@inlinable
public func barYAxisPOIMarkerX<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ height: T) -> T {
   return height - divideByZeroProtection(T.self, (value - min), range) * height
}

@inlinable
public func barXAxisPOIMarkerX<T: BinaryInteger, U: BinaryFloatingPoint>(_ value: T, _ count: T, _ width: U) -> U {
    let section = divideByZeroProtection(U.self, width, U(count))
    return (U(value) * section) + (section / 2)
}

@inlinable
public func horizontalBarYPosition<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ width: T) -> T {
    return divideByZeroProtection(T.self, (value - min), range) * width
}

@inlinable
public func horizontalBarXAxisPOIMarkerY<T: BinaryInteger, U: BinaryFloatingPoint>(_ value: T, _ count: T, _ height: U) -> U {
    return divideByZeroProtection(U.self, height, U(count)) * U(value) + ((height / U(count)) / 2)
}
