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
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = CGPoint(x: CGFloat(firstIndex) * x,
                                 y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addLine(to: nextPoint)
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
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = CGPoint(x: CGFloat(firstIndex) * x,
                                 y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in firstIndex ..< dataPoints.count {
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
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = CGPoint(x: CGFloat(firstIndex) * x,
                                 y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addLine(to: nextPoint)
            lastIndex = index
        }
        
        path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                 y: rect.height))
        path.addLine(to: CGPoint(x: CGFloat(dataPoints.distance(to: firstIndex)) * x,
                                 y: rect.height))
        path.addLine(to: firstPoint)
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

        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = CGPoint(x: CGFloat(firstIndex) * x,
                                 y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)

        var previousPoint = firstPoint

        for index in firstIndex ..< dataPoints.count {
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
        path.addLine(to: CGPoint(x: CGFloat(dataPoints.distance(to: firstIndex)) * x,
                                 y: rect.height))
        path.addLine(to: firstPoint)
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
        
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointUpper = CGPoint(x: CGFloat(firstIndex) * x,
                                      y: (CGFloat(firstDataPoint.upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)
        
        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPointUpper = CGPoint(x: CGFloat(indexUpper) * x,
                                         y: (CGFloat(datapoint.upperValue - minValue) * -y) + rect.height)
            path.addLine(to: nextPointUpper)
        }
        
        // Lower Path
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPointLower = CGPoint(x: CGFloat(indexLower) * x,
                                         y: (CGFloat(datapoint.lowerValue - minValue) * -y) + rect.height)
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

        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointUpper = CGPoint(x: CGFloat(firstIndex) * x,
                                      y: (CGFloat(firstDataPoint.upperValue - minValue) * -y) + rect.height)
        path.move(to: firstPointUpper)

        var previousPoint = firstPointUpper

        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
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
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
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

// MARK: - Bar Spacing
extension Path {
    internal static func straightLineBarSpacing<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardDataPointProtocol & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = CGPoint(x: CGFloat(firstIndex) * x,
                                 y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addLine(to: nextPoint)
        }
        return path
    }
    
    internal static func curvedLineBarSpacing<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardDataPointProtocol & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointOne = CGPoint(x: CGFloat(firstIndex) * x,
                                    y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.move(to: firstPointOne)
        
        let firstPointTwo: CGPoint = CGPoint(x: CGFloat(firstIndex) + (x / 2),
                                             y: (CGFloat(firstDataPoint.value - minValue) * -y) + rect.height)
        path.addLine(to: firstPointTwo)
        
        var previousPoint = firstPointTwo
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        guard let lastIndex = dataPoints.lastIndex(where: { !$0.ignore }) else { return path }
        let lastDatapoint = dataPoints[lastIndex]
        let lastPoint: CGPoint = CGPoint(x: (CGFloat(dataPoints.distance(to: lastIndex)) * x),
                                         y: (CGFloat(lastDatapoint.value - minValue) * -y) + rect.height)
        path.addLine(to: lastPoint)
        
        return path
    }
}
