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

// MARK: - Touch
extension CTChartData {
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }
}

extension CTChartData {
    
    /**
     Displays the data points value with the unit.
     
     - Parameter info: A data point
     - Returns: Text View with the value with relevent info.
     */
    public func infoValueUnit(info: DataPoint) -> some View {
        switch self.infoView.touchUnit {
        case .none:
            return Text(LocalizedStringKey(info.valueAsString(specifier: infoView.touchSpecifier,
                                                              formatter: infoView.touchFormatter)))
        case .prefix(of: let unit):
            return Text(LocalizedStringKey(unit + " " + info.valueAsString(specifier: infoView.touchSpecifier,
                                                                           formatter: infoView.touchFormatter)))
        case .suffix(of: let unit):
            return Text(LocalizedStringKey(info.valueAsString(specifier: infoView.touchSpecifier,
                                                              formatter: infoView.touchFormatter) + " " + unit))
        }
    }
    
    /**
     Displays the data points value without the unit.
     
     - Parameter info: A data point
     - Returns: Text View with the value with relevent info.
     */
    public func infoValue(info: DataPoint) -> some View {
        Text(LocalizedStringKey(info.valueAsString(specifier: infoView.touchSpecifier, formatter: infoView.touchFormatter)))
    }
    
    /**
     Displays the unit.
     
     - Parameter info: A data point
     - Returns: Text View of the unit.
     */
    public func infoUnit() -> some View {
        switch self.infoView.touchUnit {
        case .none:
            return Text("")
        case .prefix(of: let unit):
            return Text(LocalizedStringKey("\(unit)"))
        case .suffix(of: let unit):
            return Text(LocalizedStringKey("\(unit)"))
        }
    }
    
    /**
     Displays the data points description.
     
     - Parameter info: A data point
     - Returns: Text View with the points description.
     */
    public func infoDescription(info: DataPoint) -> some View {
        Text(LocalizedStringKey(info.wrappedDescription))
    }
    
    /**
     Displays the relevent Legend for the data point.
     
     - Parameter info: A data point
     - Returns: A View of a Legend.
     */
    @ViewBuilder public func infoLegend(info: DataPoint) -> some View {
        if let legend = self.legends.first(where: {
            $0.legend == info.legendTag
        }) {
            legend.getLegendAsCircle(textColor: .primary)
        } else {
            EmptyView()
        }
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
        return returnPoint + (self.viewData.yAxisLabelWidth.max() ?? 0) + self.viewData.yAxisTitleWidth + (self.viewData.hasYAxisLabels ? 4 : 0) // +4 For Padding
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
        return returnPoint
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


extension CTSingleDataSetProtocol where Self.DataPoint: CTStandardDataPointProtocol & CTnotRanged,
                                        Self: CTLineChartDataSet {
    public func minValue() -> Double  {
        if !self.style.ignoreZero {
            return self.dataPoints
                .map(\.value)
                .min() ?? 0
        } else {
            return self.dataPoints
                .map(\.value)
                .filter({ $0 != 0 })
                .min() ?? 0
        }
    }
}

extension CTMultiDataSetProtocol where Self.DataSet: CTLineChartDataSet,
                                       Self.DataSet.DataPoint: CTStandardDataPointProtocol {
    public func minValue() -> Double {
        dataSets.compactMap { dataSet in
            if !dataSet.style.ignoreZero {
                return  dataSet.dataPoints
                    .map(\.value)
                    .min()
            } else {
                return dataSet.dataPoints
                    .filter { $0.value != 0 }
                    .map(\.value)
                    .min()
            }
        }.min() ?? 100
    }
}

// MARK: - Data Point
extension CTDataPointBaseProtocol  {
    /// Returns information about the data point for use in accessibility tags.
    func getCellAccessibilityValue(
        specifier: String,
        formatter: NumberFormatter?
    ) -> Text {
        Text(String(format: NSLocalizedString("%@ \(wrappedDescription)", comment: ""), "\(valueAsString(specifier: specifier, formatter: formatter))"))
    }
}

extension CTDataPointBaseProtocol {
    /// Unwraps description
    public var wrappedDescription: String {
        self.description ?? ""
    }
}

extension CTStandardDataPointProtocol where Self: CTBarDataPointBaseProtocol {
    /// Data point's value as a string
    public func valueAsString(specifier: String, formatter: NumberFormatter?) -> String {
        if let formatter = formatter {
            return formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
        } else {
            return String(format: specifier, value)
        }
    }
}
extension CTStandardDataPointProtocol where Self: CTLineDataPointProtocol & IgnoreMe {
    /// Data point's value as a string
    public func valueAsString(specifier: String, formatter: NumberFormatter?) -> String {
        if let formatter = formatter {
            return formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
        } else {
            if !self.ignoreMe {
                return String(format: specifier, value)
            } else {
                return String("")
            }
        }
    }
}
extension CTStandardDataPointProtocol where Self: CTPieDataPoint {
    /// Data point's value as a string
    public func valueAsString(specifier: String, formatter: NumberFormatter?) -> String {
        if let formatter = formatter {
            return formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
        } else {
            return String(format: specifier, value)
        }
    }
}

extension CTRangeDataPointProtocol where Self == RangedBarDataPoint {
    /// Data point's value as a string
    public func valueAsString(specifier: String, formatter: NumberFormatter?) -> String {
        if let formatter = formatter {
            return (formatter.string(from: NSNumber(floatLiteral: lowerValue)) ?? "") + "-" + (formatter.string(from: NSNumber(floatLiteral: upperValue)) ?? "")
        } else {
            if !self._valueOnly {
                return String(format: specifier, lowerValue) + "-" + String(format: specifier, upperValue)
            } else {
                return String(format: specifier, self._value)
            }
        }
    }
}

extension CTRangedLineDataPoint where Self == RangedLineChartDataPoint {
    /// Data point's value as a string
    public func valueAsString(specifier: String, formatter: NumberFormatter?) -> String {
        if let formatter = formatter {
            return formatter.string(from: NSNumber(floatLiteral: value)) ?? ""
        } else {
            if !self._valueOnly {
                return String(format: specifier, lowerValue) + "-" + String(format: specifier, upperValue)
            } else {
                return String(format: specifier, value)
            }
        }
    }
}
