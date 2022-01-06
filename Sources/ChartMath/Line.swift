//
//  Line.swift
//  
//
//  Created by Will Dale on 06/01/2022.
//

import Foundation
import CoreGraphics

public func plotPointX<T: BinaryFloatingPoint>(w: T, i: Int, c: Int) -> T {
    let xSize = (w / T(c-1))
    let x = T(i) * xSize
    return x
}

public func plotPoint<T: BinaryFloatingPoint>(v: T, m: T, r: T, i: Int, c: Int, w: T, h: T) -> CGPoint {
    let xSize = (w / T(c-1))
    let x = T(i) * xSize
    
    let yValue = v - m
    let ySizing = -(h / r)
    let y = (yValue * ySizing) + h
    return CGPoint(x: CGFloat(x), y: CGFloat(y))
}

public func plotPointWithBarOffset<T: BinaryFloatingPoint>(v: T, m: T, r: T, i: Int, c: Int, w: T, h: T) -> CGPoint {
    let xSize = (w / T(c-1))
    let x = T(i) * xSize
    let os = x / 2
    
    let yValue = v - m
    let ySizing = -(h / r)
    let y = (yValue * ySizing) + h
    return CGPoint(x: CGFloat(x + os), y: CGFloat(y))
}

public func cubicBezierC1(pp: CGPoint, np: CGPoint) -> CGPoint {
    return CGPoint(x: pp.x + (np.x - pp.x) / 2,
                   y: pp.y)
}

public func cubicBezierC2(pp: CGPoint, np: CGPoint) -> CGPoint {
    CGPoint(x: np.x - (np.x - pp.x) / 2,
            y: np.y)
}
