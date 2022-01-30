//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Main line shape
 */
internal struct LineShape<DP>: Shape where DP: CTStandardDataPointProtocol & IgnoreMe {
    
    private let dataPoints: [DP]
    private let lineType: LineType
    private let isFilled: Bool
    private let minValue: Double
    private let range: Double
    private let ignoreZero: Bool
    
    internal init(
        dataPoints: [DP],
        lineType: LineType,
        isFilled: Bool,
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.isFilled = isFilled
        self.minValue = minValue
        self.range = range
        self.ignoreZero = ignoreZero
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            switch ignoreZero {
            case false:
                return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            case true:
                return Path.curvedLineIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            }
        case .line:
            switch ignoreZero {
            case false:
                return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            case true:
                return Path.straightLineIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            }
        case .stepped:
            switch ignoreZero {
            case false:
                return Path.steppedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            case true:
                return Path.steppedLineIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
            }
        }
    }
}

/**
 Background fill based on the upper and lower values
 for a Ranged Line Chart.
 */
internal struct RangedLineFillShape<DP>: Shape where DP: CTRangedLineDataPoint & IgnoreMe {
    
    private let dataPoints: [DP]
    private let lineType: LineType
    private let minValue: Double
    private let range: Double
    private let ignoreZero: Bool
    
    internal init(
        dataPoints: [DP],
        lineType: LineType,
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.minValue = minValue
        self.range = range
        self.ignoreZero = ignoreZero
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            switch ignoreZero {
            case false:
                return Path.curvedLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            case true:
                return Path.curvedLineBoxIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            }
        case .line:
            switch ignoreZero {
            case false:
                return Path.straightLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            case true:
                return Path.straightLineBoxIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            }
        case .stepped:
            switch ignoreZero {
            case false:
                return Path.steppedLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            case true:
                return Path.steppedLineBoxIgnoreZero(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
            }
        }
    }
}

