//
//  PathExtensions.swift
//  
//
//  Created by Will Dale on 10/02/2021.
//

import SwiftUI
import ChartMath

// MARK: Standard
extension Path {
    internal static func straightLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardDataPointProtocol & Ignorable {
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = plotPoint(firstDataPoint.value,
                                   minValue,
                                   range,
                                   firstIndex,
                                   dataPoints.count,
                                   rect.width,
                                   rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(datapoint.value,
                                      minValue,
                                      range,
                                      index,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
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
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = plotPoint(firstDataPoint.value,
                                   minValue,
                                   range,
                                   firstIndex,
                                   dataPoints.count,
                                   rect.width,
                                   rect.height)
        path.move(to: firstPoint)
        var previousPoint = firstPoint
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(datapoint.value,
                                      minValue,
                                      range,
                                      index,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(previousPoint, nextPoint),
                          control2: cubicBezierC2(previousPoint, nextPoint))
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
        var lastIndex: Int = 0
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = plotPoint(firstDataPoint.value,
                                   minValue,
                                   range,
                                   firstIndex,
                                   dataPoints.count,
                                   rect.width,
                                   rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(datapoint.value,
                                      minValue,
                                      range,
                                      index,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
            path.addLine(to: nextPoint)
            lastIndex = index
        }
        
        path.addLine(to: CGPoint(x: plotPointX(lastIndex, dataPoints.count, rect.width),
                                 y: rect.height))
        path.addLine(to: CGPoint(x: plotPointX(dataPoints.distance(to: firstIndex), dataPoints.count, rect.width),
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
        var lastIndex: Int = 0
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = plotPoint(firstDataPoint.value,
                                   minValue,
                                   range,
                                   firstIndex,
                                   dataPoints.count,
                                   rect.width,
                                   rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = plotPoint(datapoint.value,
                                      minValue,
                                      range,
                                      index,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(previousPoint, nextPoint),
                          control2: cubicBezierC2(previousPoint, nextPoint))
            previousPoint = nextPoint
            lastIndex = index
        }
        path.addLine(to: CGPoint(x: plotPointX(lastIndex, dataPoints.count, rect.width),
                                 y: rect.height))
        path.addLine(to: CGPoint(x: plotPointX(dataPoints.distance(to: firstIndex), dataPoints.count, rect.width),
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
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointUpper = plotPoint(firstDataPoint.upperValue,
                                        minValue,
                                        range,
                                        firstIndex,
                                        dataPoints.count,
                                        rect.width,
                                        rect.height)
        path.move(to: firstPointUpper)
        
        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPointUpper = plotPoint(datapoint.upperValue,
                                           minValue,
                                           range,
                                           indexUpper,
                                           dataPoints.count,
                                           rect.width,
                                           rect.height)
            path.addLine(to: nextPointUpper)
        }
        
        // Lower Path
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPointLower = plotPoint(datapoint.lowerValue,
                                           minValue,
                                           range,
                                           indexLower,
                                           dataPoints.count,
                                           rect.width,
                                           rect.height)
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
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointUpper = plotPoint(firstDataPoint.upperValue,
                                        minValue,
                                        range,
                                        firstIndex,
                                        dataPoints.count,
                                        rect.width,
                                        rect.height)
        path.move(to: firstPointUpper)
        
        var previousPoint = firstPointUpper
        
        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(datapoint.upperValue,
                                      minValue,
                                      range,
                                      indexUpper,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(previousPoint, nextPoint),
                          control2: cubicBezierC2(previousPoint, nextPoint))
            previousPoint = nextPoint
        }
        
        // Lower Path
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(datapoint.lowerValue,
                                      minValue,
                                      range,
                                      indexLower,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(previousPoint, nextPoint),
                          control2: cubicBezierC2(previousPoint, nextPoint))
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
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPoint = plotPointWithBarOffset(firstDataPoint.value,
                                                minValue,
                                                range,
                                                firstIndex,
                                                dataPoints.count,
                                                rect.width,
                                                rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = plotPointWithBarOffset(datapoint.value,
                                                   minValue,
                                                   range,
                                                   index,
                                                   dataPoints.count,
                                                   rect.width,
                                                   rect.height)
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
        var path = Path()
        guard let firstIndex = dataPoints.firstIndex(where: { !$0.ignore }) else { return path }
        let firstDataPoint = dataPoints[firstIndex]
        let firstPointOne = plotPoint(firstDataPoint.value,
                                      minValue,
                                      range,
                                      firstIndex,
                                      dataPoints.count,
                                      rect.width,
                                      rect.height)
        path.move(to: firstPointOne)
        
        let firstPointTwo = plotPointWithBarOffset(firstDataPoint.value,
                                                   minValue,
                                                   range,
                                                   firstIndex,
                                                   dataPoints.count,
                                                   rect.width,
                                                   rect.height)
        path.addLine(to: firstPointTwo)
        
        var previousPoint = firstPointTwo
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPointWithBarOffset(datapoint.value,
                                                   minValue,
                                                   range,
                                                   index,
                                                   dataPoints.count,
                                                   rect.width,
                                                   rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(previousPoint, nextPoint),
                          control2: cubicBezierC2(previousPoint, nextPoint))
            previousPoint = nextPoint
        }
        
        guard let lastIndex = dataPoints.lastIndex(where: { !$0.ignore }) else { return path }
        let lastDatapoint = dataPoints[lastIndex]
        let lastPoint = plotPoint(lastDatapoint.value,
                                  minValue,
                                  range,
                                  lastIndex,
                                  dataPoints.count,
                                  rect.width,
                                  rect.height)
        path.addLine(to: lastPoint)
        
        return path
    }
}
