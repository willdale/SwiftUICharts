//
//  Line.swift
//  
//
//  Created by Will Dale on 06/01/2022.
//

import Foundation
import CoreGraphics

@inlinable
public func plotPointX<T: BinaryFloatingPoint>(_ index: Int, _ count: Int, _ width: T) -> T {
    let xSize = (width / T(count - 1))
    return T(index) * xSize
}

@inlinable
public func plotPointY<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ height: T) -> T {
    let yValue = value - min
    let ySizing = -(height / range)
    return (yValue * ySizing) + height
}

@inlinable
public func plotPoint<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ index: Int, _ count: Int, _ width: T, _ height: T) -> CGPoint {
    let xSize = (width / T(count - 1))
    let x = T(index) * xSize
    
    let yValue = value - min
    let ySizing = -(height / range)
    let y = (yValue * ySizing) + height
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
}

@inlinable
public func plotPointWithBarOffset<T: BinaryFloatingPoint>(_ value: T, _ min: T, _ range: T, _ index: Int, _ count: Int, _ width: T, _ height: T) -> CGPoint {
    let xSize = (width / T(count - 1))
    let x = T(index) * xSize
    let offset = x / 2
    
    let yValue = value - min
    let ySizing = -(height / range)
    let y = (yValue * ySizing) + height
    return CGPoint(x: CGFloat(x + offset), y: CGFloat(y))
}

@inlinable
public func cubicBezierC1(_ previousPoint: CGPoint, _ nextPoint: CGPoint) -> CGPoint {
    return CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                   y: previousPoint.y)
}

@inlinable
public func cubicBezierC2(_ previousPoint: CGPoint, _ nextPoint: CGPoint) -> CGPoint {
    CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
            y: nextPoint.y)
}


// MARK: Axis
@inlinable
public func lineXAxisPOIMarkerX<T: BinaryInteger, U: BinaryFloatingPoint>(_ value: T, _ count: T, _ width: U) -> U {
    return divideByZeroProtection(U.self, width, U(count - 1)) * U(value)
}

