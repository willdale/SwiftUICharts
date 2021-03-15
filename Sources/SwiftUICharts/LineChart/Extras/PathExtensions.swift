//
//  PathExtensions.swift
//  
//
//  Created by Will Dale on 10/02/2021.
//

import SwiftUI

extension Path {
    /// Draws straight lines between data points.
    static func straightLine<DP:CTStandardDataPointProtocol>(
        rect: CGRect,
        dataPoints: [DP],
        minValue: Double,
        range: Double,
        isFilled: Bool,
        ignoreZero: Bool
    ) -> Path {
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        var path = Path()
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        
        path.move(to: firstPoint)
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index].value - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addLine(to: nextPoint)
            } else {
                if dataPoints[index].value != 0 {
                    path.addLine(to: nextPoint)
                }
            }
            
        }
        if isFilled {
            path.addLine(to: CGPoint(x: CGFloat(dataPoints.count-1) * x,  y: rect.height))
            path.addLine(to: CGPoint(x: 0, y: rect.height))
            path.closeSubpath()
        }
        return path
    }
    
    /// Draws cubic Bézier curved lines between data points.
    static func curvedLine<DP:CTStandardDataPointProtocol>(
        rect: CGRect,
        dataPoints: [DP],
        minValue: Double,
        range: Double,
        isFilled: Bool,
        ignoreZero: Bool
    ) -> Path {
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        var path = Path()
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        var previousPoint = firstPoint
        var lastIndex : Int = 0
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index].value - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addCurve(to: nextPoint,
                              control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                y: previousPoint.y),
                              control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                y: nextPoint.y))
                lastIndex = index
            } else {
                if dataPoints[index].value != 0 {
                    path.addCurve(to: nextPoint,
                                  control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                    y: previousPoint.y),
                                  control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                    y: nextPoint.y))
                    lastIndex = index
                }
            }
            
            previousPoint = nextPoint
        }
        if isFilled {
            // Draw line straight down from last value
            path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                     y: rect.height))
            
            // Draw line back to start along x axis
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            // close back to first data point
            path.closeSubpath()
        }
        return path
    }
    
    
    /// Draws straight lines between data points.
    static func straightLineBox<DP:CTRangedLineDataPoint>(
        rect: CGRect,
        dataPoints: [DP],
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) -> Path {
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        
        var path = Path()
        
        // Upper Path
        let firstPointUpper = CGPoint(x: 0,
                                      y: (CGFloat(dataPoints[0].upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)
        for indexUpper in 1 ..< dataPoints.count {
            let nextPointUpper = CGPoint(x: CGFloat(indexUpper) * x,
                                         y: (CGFloat(dataPoints[indexUpper].upperValue - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addLine(to: nextPointUpper)
            } else {
                if dataPoints[indexUpper].value != 0 {
                    path.addLine(to: nextPointUpper)
                    
                }
            }
        }
        
        // Lower Path
        for indexLower in (0 ..< dataPoints.count).reversed() {
            let nextPointLower = CGPoint(x: CGFloat(indexLower) * x,
                                         y: (CGFloat(dataPoints[indexLower].lowerValue - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addLine(to: nextPointLower)
            } else {
                if dataPoints[indexLower].value != 0 {
                    path.addLine(to: nextPointLower)
                }
            }
        }
        
        path.addLine(to: firstPointUpper)
        
        return path
    }
    
    /// Draws straight lines between data points.
    static func curvedLineBox<DP:CTRangedLineDataPoint>(
        rect: CGRect,
        dataPoints: [DP],
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) -> Path {
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        
        var path = Path()
        
        // Upper Path
        let firstPointUpper = CGPoint(x: 0,
                                      y: (CGFloat(dataPoints[0].upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)
        
        var previousPoint = firstPointUpper
        
        for indexUpper in 1 ..< dataPoints.count {
            
            let nextPoint = CGPoint(x: CGFloat(indexUpper) * x,
                                    y: (CGFloat(dataPoints[indexUpper].upperValue - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addCurve(to: nextPoint,
                              control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                y: previousPoint.y),
                              control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                y: nextPoint.y))
            } else {
                if dataPoints[indexUpper].value != 0 {
                    path.addCurve(to: nextPoint,
                                  control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                    y: previousPoint.y),
                                  control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                    y: nextPoint.y))
                }
            }
            previousPoint = nextPoint
        }
        
        // Lower Path
        for indexLower in (0 ..< dataPoints.count).reversed() {
            let nextPoint = CGPoint(x: CGFloat(indexLower) * x,
                                    y: (CGFloat(dataPoints[indexLower].lowerValue - minValue) * -y) + rect.height)
            
            if !ignoreZero {
                path.addCurve(to: nextPoint,
                              control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                y: previousPoint.y),
                              control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                y: nextPoint.y))
            } else {
                if dataPoints[indexLower].value != 0 {
                    path.addCurve(to: nextPoint,
                                  control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                                    y: previousPoint.y),
                                  control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                                    y: nextPoint.y))
                }
            }
            previousPoint = nextPoint
        }
        
        path.addLine(to: firstPointUpper)
        
        return path
        
    }
}
