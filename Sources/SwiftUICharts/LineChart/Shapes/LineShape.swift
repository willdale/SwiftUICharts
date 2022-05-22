//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI
import ChartMath

fileprivate final class LineShapeCache {
    var lineHash: Int?
    var rect: CGRect?
    var path = Path()
}

internal struct LineShape<DataPoint>: Shape where DataPoint: CTStandardDataPointProtocol & Ignorable {
    
    private let dataPoints: [DataPoint]
    private let lineType: LineType
    private let minValue: Double
    private let range: Double
    
    internal init(
        dataPoints: [DataPoint],
        lineType: LineType,
        minValue: Double,
        range: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.minValue = minValue
        self.range = range
    }
    
    fileprivate var cache = LineShapeCache()
    
    internal func path(in rect: CGRect) -> Path {
        if cache.lineHash == lineHash && cache.rect == rect {
            return cache.path
        }
        
        var path = Path()
        switch lineType {
        case .curvedLine:
            path = Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            path = Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
        cache.lineHash = dataPoints.hashValue
        cache.rect = rect
        cache.path = path
        return path
    }
    
    var lineHash: Int {
        var hasher = Hasher()
        hasher.combine(dataPoints)
        hasher.combine(lineType)
        return hasher.finalize()
    }
}

// Filled line chart backing
internal struct FilledLine: Shape {
    
    private let dataPoints: [LineChartDataPoint]
    private let lineType: LineType
    private let minValue: Double
    private let range: Double
    
    internal init(
        dataPoints: [LineChartDataPoint],
        lineType: LineType,
        minValue: Double,
        range: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.minValue = minValue
        self.range = range
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.filledCurvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            return Path.filledStraightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

// Ranged line chart backing
internal struct RangedLineFillShape<DataPoint>: Shape where DataPoint: CTRangedLineDataPoint & Ignorable {
    
    private let dataPoints: [DataPoint]
    private let lineType: LineType
    private let minValue: Double
    private let range: Double
    
    internal init(
        dataPoints: [DataPoint],
        lineType: LineType,
        minValue: Double,
        range: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.minValue = minValue
        self.range = range
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.curvedLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            return Path.straightLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

