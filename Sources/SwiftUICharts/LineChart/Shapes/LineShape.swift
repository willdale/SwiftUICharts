//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

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
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
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

