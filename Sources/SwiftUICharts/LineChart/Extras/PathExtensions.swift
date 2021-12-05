//
//  PathExtensions.swift
//  
//
//  Created by Will Dale on 10/02/2021.
//

import SwiftUI

// MARK: Standard
extension Path {
    internal static func straightLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardDataPointProtocol & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        if dataPoints.count >= 2 {
            
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            
            for index in 1 ..< dataPoints.count {
                let datapoint = dataPoints[index]
                if datapoint.ignore { continue }
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    internal static func curvedLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardDataPointProtocol & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPoint: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        return path
    }
}

// MARK: - Filled
extension Path {
    internal static func filledStraightLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var lastIndex: Int = 0
        var path = Path()
        
        if dataPoints.count >= 2 {
            
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            
            for index in 1 ..< dataPoints.count {
                let datapoint = dataPoints[index]
                if datapoint.ignore { continue }
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
                lastIndex = index
            }
            
            path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                     y: rect.height))
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            path.closeSubpath()
        }
        return path
    }
    
    internal static func filledCurvedLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var lastIndex: Int = 0
        var path = Path()
        
        let firstPoint: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
            lastIndex = index
        }
        path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                 y: rect.height))
        path.addLine(to: CGPoint(x: 0,
                                 y: rect.height))
        path.closeSubpath()
        return path
    }
}



// MARK: - Box
extension Path {
    internal static func straightLineBox<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTRangedLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        
        var path = Path()
        
        // Upper Path
        let firstPointUpper = CGPoint(x: 0,
                                      y: (CGFloat(dataPoints[0].upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)
        
        for indexUpper in 1 ..< dataPoints.count {
            let nextPointUpper = CGPoint(x: CGFloat(indexUpper) * x,
                                         y: (CGFloat(dataPoints[indexUpper].upperValue - minValue) * -y) + rect.height)
            path.addLine(to: nextPointUpper)
        }
        
        // Lower Path
        for indexLower in (0 ..< dataPoints.count).reversed() {
            let nextPointLower = CGPoint(x: CGFloat(indexLower) * x,
                                         y: (CGFloat(dataPoints[indexLower].lowerValue - minValue) * -y) + rect.height)
            
            path.addLine(to: nextPointLower)
            
        }
        
        path.addLine(to: firstPointUpper)
        
        return path
    }
    
    internal static func curvedLineBox<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTRangedLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        
        var path = Path()
        
        // Upper Path
        let firstPointUpper = CGPoint(x: 0,
                                      y: (CGFloat(dataPoints[0].upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)
        
        var previousPoint = firstPointUpper
        
        for indexUpper in 1 ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPoint = CGPoint(x: CGFloat(indexUpper) * x,
                                    y: (CGFloat(datapoint.upperValue - minValue) * -y) + rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        // Lower Path
        for indexLower in (0 ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPoint = CGPoint(x: CGFloat(indexLower) * x,
                                    y: (CGFloat(datapoint.lowerValue - minValue) * -y) + rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        path.addLine(to: firstPointUpper)
        
        return path
    }
}
