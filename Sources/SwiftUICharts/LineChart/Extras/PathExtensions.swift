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
        let firstPoint = plotPoint(v: firstDataPoint.value,
                                   m: minValue,
                                   r: range,
                                   i: firstIndex,
                                   c: dataPoints.count,
                                   w: rect.width,
                                   h: rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(v: datapoint.value,
                                      m: minValue,
                                      r: range,
                                      i: index,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
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
        let firstPoint = plotPoint(v: firstDataPoint.value,
                                   m: minValue,
                                   r: range,
                                   i: firstIndex,
                                   c: dataPoints.count,
                                   w: rect.width,
                                   h: rect.height)
        path.move(to: firstPoint)
        var previousPoint = firstPoint
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(v: datapoint.value,
                                      m: minValue,
                                      r: range,
                                      i: index,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(pp: previousPoint, np: nextPoint),
                          control2: cubicBezierC2(pp: previousPoint, np: nextPoint))
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
        let firstPoint = plotPoint(v: firstDataPoint.value,
                                   m: minValue,
                                   r: range,
                                   i: firstIndex,
                                   c: dataPoints.count,
                                   w: rect.width,
                                   h: rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(v: datapoint.value,
                                      m: minValue,
                                      r: range,
                                      i: index,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
            path.addLine(to: nextPoint)
            lastIndex = index
        }
        
        path.addLine(to: CGPoint(x: plotPointX(w: rect.width, i: lastIndex, c: dataPoints.count),
                                 y: rect.height))
        path.addLine(to: CGPoint(x: plotPointX(w: rect.width, i: dataPoints.distance(to: firstIndex), c: dataPoints.count),
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
        let firstPoint = plotPoint(v: firstDataPoint.value,
                                   m: minValue,
                                   r: range,
                                   i: firstIndex,
                                   c: dataPoints.count,
                                   w: rect.width,
                                   h: rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = plotPoint(v: datapoint.value,
                                      m: minValue,
                                      r: range,
                                      i: index,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(pp: previousPoint, np: nextPoint),
                          control2: cubicBezierC2(pp: previousPoint, np: nextPoint))
            previousPoint = nextPoint
            lastIndex = index
        }
        path.addLine(to: CGPoint(x: plotPointX(w: rect.width, i: lastIndex, c: dataPoints.count),
                                 y: rect.height))
        path.addLine(to: CGPoint(x: plotPointX(w: rect.width, i: dataPoints.distance(to: firstIndex), c: dataPoints.count),
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
        let firstPointUpper = plotPoint(v: firstDataPoint.upperValue,
                                        m: minValue,
                                        r: range,
                                        i: firstIndex,
                                        c: dataPoints.count,
                                        w: rect.width,
                                        h: rect.height)
        path.move(to: firstPointUpper)
        
        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPointUpper = plotPoint(v: datapoint.upperValue,
                                           m: minValue,
                                           r: range,
                                           i: indexUpper,
                                           c: dataPoints.count,
                                           w: rect.width,
                                           h: rect.height)
            path.addLine(to: nextPointUpper)
        }
        
        // Lower Path
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPointLower = plotPoint(v: datapoint.lowerValue,
                                           m: minValue,
                                           r: range,
                                           i: indexLower,
                                           c: dataPoints.count,
                                           w: rect.width,
                                           h: rect.height)
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
        let firstPointUpper = plotPoint(v: firstDataPoint.upperValue,
                                        m: minValue,
                                        r: range,
                                        i: firstIndex,
                                        c: dataPoints.count,
                                        w: rect.width,
                                        h: rect.height)
        path.move(to: firstPointUpper)
        
        var previousPoint = firstPointUpper
        
        // Upper Path
        for indexUpper in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[indexUpper]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(v: datapoint.upperValue,
                                      m: minValue,
                                      r: range,
                                      i: indexUpper,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(pp: previousPoint, np: nextPoint),
                          control2: cubicBezierC2(pp: previousPoint, np: nextPoint))
            previousPoint = nextPoint
        }
        
        // Lower Path
        for indexLower in (firstIndex ..< dataPoints.count).reversed() {
            let datapoint = dataPoints[indexLower]
            if datapoint.ignore { continue }
            let nextPoint = plotPoint(v: datapoint.lowerValue,
                                      m: minValue,
                                      r: range,
                                      i: indexLower,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(pp: previousPoint, np: nextPoint),
                          control2: cubicBezierC2(pp: previousPoint, np: nextPoint))
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
        let firstPoint = plotPointWithBarOffset(v: firstDataPoint.value,
                                                m: minValue,
                                                r: range,
                                                i: firstIndex,
                                                c: dataPoints.count,
                                                w: rect.width,
                                                h: rect.height)
        path.move(to: firstPoint)
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = plotPointWithBarOffset(v: datapoint.value,
                                                   m: minValue,
                                                   r: range,
                                                   i: index,
                                                   c: dataPoints.count,
                                                   w: rect.width,
                                                   h: rect.height)
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
        let firstPointOne = plotPoint(v: firstDataPoint.value,
                                      m: minValue,
                                      r: range,
                                      i: firstIndex,
                                      c: dataPoints.count,
                                      w: rect.width,
                                      h: rect.height)
        path.move(to: firstPointOne)
        
        let firstPointTwo = plotPointWithBarOffset(v: firstDataPoint.value,
                                                   m: minValue,
                                                   r: range,
                                                   i: firstIndex,
                                                   c: dataPoints.count,
                                                   w: rect.width,
                                                   h: rect.height)
        path.addLine(to: firstPointTwo)
        
        var previousPoint = firstPointTwo
        
        for index in firstIndex ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            let nextPoint = plotPointWithBarOffset(v: datapoint.value,
                                                   m: minValue,
                                                   r: range,
                                                   i: index,
                                                   c: dataPoints.count,
                                                   w: rect.width,
                                                   h: rect.height)
            path.addCurve(to: nextPoint,
                          control1: cubicBezierC1(pp: previousPoint, np: nextPoint),
                          control2: cubicBezierC2(pp: previousPoint, np: nextPoint))
            previousPoint = nextPoint
        }
        
        guard let lastIndex = dataPoints.lastIndex(where: { !$0.ignore }) else { return path }
        let lastDatapoint = dataPoints[lastIndex]
        let lastPoint = plotPoint(v: lastDatapoint.value,
                                  m: minValue,
                                  r: range,
                                  i: lastIndex,
                                  c: dataPoints.count,
                                  w: rect.width,
                                  h: rect.height)
        path.addLine(to: lastPoint)
        
        return path
    }
}
