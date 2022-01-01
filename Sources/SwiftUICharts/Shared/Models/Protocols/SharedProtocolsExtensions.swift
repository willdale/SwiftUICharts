//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Is Greater Than
extension CTChartData where Self: CTLineChartDataProtocol,
                            SetType: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 2
    }
}

extension CTChartData where Self: CTBarChartDataProtocol,
                            SetType: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 1
    }
}

extension CTChartData where Self: CTPieDoughnutChartDataProtocol,
                            SetType: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 1
    }
}

extension CTChartData where Self: CTLineChartDataProtocol,
                            SetType: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: [Bool] = []
        dataSets.dataSets.forEach { dataSet in
            returnValue.append(dataSet.dataPoints.count >= 2)
        }
        return returnValue.first(where: { $0 == true }) ?? false
    }
}

extension CTChartData where Self: CTBarChartDataProtocol,
                            SetType: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: [Bool] = []
        dataSets.dataSets.forEach { dataSet in
            returnValue.append(dataSet.dataPoints.count >= 1)
        }
        return returnValue.first(where: { $0 == true }) ?? false
    }
}

extension CTLineBarChartDataProtocol {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + (viewData.yAxisLabelWidth.max() ?? 0) + viewData.yAxisTitleWidth + (viewData.hasYAxisLabels ? 4 : 0) // +4 For Padding
    }
}
extension CTLineBarChartDataProtocol where Self: isHorizontal {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minY + (boxFrame.height / 2) {
            returnPoint = chartSize.minY + (boxFrame.height / 2)
        } else if touchLocation > chartSize.maxY - (boxFrame.height / 2) {
            returnPoint = chartSize.maxY - (boxFrame.height / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + (viewData.xAxisLabelHeights.max() ?? 0) + viewData.xAxisTitleHeight + (viewData.hasXAxisLabels ? 4 : 0)
    }
}

extension CTPieDoughnutChartDataProtocol {
    public func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        touchLocation
    }
}

// MARK: - Data Set
extension CTSingleDataSetProtocol where Self.DataPoint: CTStandardDataPointProtocol & CTnotRanged {
    public func maxValue() -> Double {
        self.dataPoints
            .map(\.value)
            .max() ?? 0
    }
    public func minValue() -> Double {
        self.dataPoints
            .map(\.value)
            .min() ?? 0
    }
    public func average() -> Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
            .divide(by: Double(self.dataPoints.count))
    }
}
extension CTSingleDataSetProtocol where Self.DataPoint: CTRangeDataPointProtocol & CTisRanged {
    public func maxValue() -> Double {
        self.dataPoints
            .map(\.upperValue)
            .max() ?? 0
    }
    public func minValue() -> Double {
        self.dataPoints
            .map(\.lowerValue)
            .min() ?? 0
    }
    public func average() -> Double {
        self.dataPoints
            .reduce(0) { $0 + ($1.upperValue - $1.lowerValue) }
            .divide(by: Double(self.dataPoints.count))
    }
}

extension CTMultiDataSetProtocol where Self.DataSet.DataPoint: CTStandardDataPointProtocol {
    public func maxValue() -> Double {
        self.dataSets.compactMap {
            $0.dataPoints
                .map(\.value)
                .max()
        }
        .max() ?? 0
    }
    public func minValue() -> Double {
        self.dataSets.compactMap {
            $0.dataPoints
                .map(\.value)
                .min()
        }
        .min() ?? 0
    }
    public func average() -> Double {
        
        self.dataSets
            .compactMap {
                $0.dataPoints
                    .map(\.value)
                    .reduce(0, +)
                    .divide(by: Double($0.dataPoints.count))
            }
            .reduce(0, +)
            .divide(by: Double(self.dataSets.count))
    }
}

extension CTMultiDataSetProtocol where Self == StackedBarDataSets {
    /**
     Returns the highest sum value in the data sets
     
     - Note:
     This differs from other charts, as Stacked Bar Charts
     need to consider the sum value for each data set, instead of the
     max value of a data point.
     
     - Returns: Highest sum value in data sets.
     */
    public func maxValue() -> Double {
        self.dataSets
            .map {
                $0.dataPoints
                    .map(\.value)
                    .reduce(0.0, +)
            }
            .max() ?? 0
    }
}
extension CTMultiBarChartDataSet where Self == StackedBarDataSet {
    /**
     Returns the highest sum value in the data set.
     
     - Note:
     This differs from other charts, as Stacked Bar Charts
     need to consider the sum value for each data set, instead of the
     max value of a data point.
     
     - Returns: Highest sum value in data set.
     */
    public func maxValue() -> Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
    }
}


// MARK: - Data Point
extension CTDataPointBaseProtocol  {
    /// Returns information about the data point for use in accessibility tags.
    func getCellAccessibilityValue(specifier: String) -> Text {
        Text(String(format: NSLocalizedString("%@ \(self.wrappedDescription)", comment: ""), "\(self.valueAsString(specifier: specifier))"))
    }
}

extension CTDataPointBaseProtocol {
    /// Unwraps description
    public var wrappedDescription: String {
        self.description ?? ""
    }
}
