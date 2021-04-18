//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

extension CTChartData where Self: CTLineChartDataProtocol,
                            Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 2
    }
}
extension CTChartData where Self: CTBarChartDataProtocol,
                            Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 1
    }
}
extension CTChartData where Self: CTPieDoughnutChartDataProtocol,
                            Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count >= 1
    }
}

extension CTChartData where Self: CTLineChartDataProtocol,
                            Set: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: [Bool] = []
        dataSets.dataSets.forEach { dataSet in
            returnValue.append(dataSet.dataPoints.count >= 2)
        }
        return returnValue.first(where: { $0 == true }) ?? false
    }
}

extension CTChartData where Self: CTBarChartDataProtocol,
                            Set: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: [Bool] = []
        dataSets.dataSets.forEach { dataSet in
            returnValue.append(dataSet.dataPoints.count >= 1)
        }
        return returnValue.first(where: { $0 == true }) ?? false
    }
}

// MARK: Touch
extension CTChartData {
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize
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
            return Text("\(info.valueAsString(specifier: self.infoView.touchSpecifier))")
        case .prefix(of: let unit):
            return Text("\(unit) \(info.valueAsString(specifier: self.infoView.touchSpecifier))")
        case .suffix(of: let unit):
            return Text("\(info.valueAsString(specifier: self.infoView.touchSpecifier)) \(unit)")
        }
    }
    
    /**
     Displays the data points value without the unit.
     
     - Parameter info: A data point
     - Returns: Text View with the value with relevent info.
     */
    public func infoValue(info: DataPoint) -> some View {
        Text("\(info.valueAsString(specifier: self.infoView.touchSpecifier))")
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
            return Text("\(unit)")
        case .suffix(of: let unit):
            return Text("\(unit)")
        }
    }
    
    /**
     Displays the data points description.
     
     - Parameter info: A data point
     - Returns: Text View with the points description.
     */
    public func infoDescription(info: DataPoint) -> some View {
        Text("\(info.wrappedDescription)")
    }
    
    /**
    Displays the relevent Legend for the data point.
    
    - Parameter info: A data point
    - Returns: A View of a Legend.
    */
    @ViewBuilder public func infoLegend(info: DataPoint) -> some View {
        if let legend = self.legends.first(where: {
            $0.prioity == 1 &&
            $0.legend == info.legendTag
        }) {
            legend.getLegendAsCircle(textColor: .primary)
        } else {
            EmptyView()
        }
    }
}

extension CTChartData {
    
    /// Sets the data point info box location while keeping it within the parent view.
    ///
    /// - Parameters:
    ///   - touchLocation: Location the user has pressed.
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    internal func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint : CGFloat = .zero
        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + self.infoView.yAxisLabelWidth
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
            .divide(self.dataPoints.count)
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
        self.dataPoints.reduce(0) { $0 + ($1.upperValue - $1.lowerValue) }
            .divide(self.dataPoints.count)
    }
}

extension CTMultiDataSetProtocol where Self.DataSet.DataPoint: CTStandardDataPointProtocol {
    public func maxValue() -> Double {
        self.dataSets.compactMap { $0.dataPoints.map(\.value).max() }
            .max() ?? 0
    }
    public func minValue() -> Double {
        self.dataSets.compactMap { $0.dataPoints.map(\.value).min() }
            .min() ?? 0
    }
    public func average() -> Double {
        self.dataSets
            .compactMap { $0.dataPoints.map(\.value).reduce(0, +) }
            .reduce(0, +)
            .divide(self.dataSets.count)
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
        let maxSums = self.dataSets.map { set in
            set.dataPoints.map(\.value).reduce(0.0, +)
        }
        return maxSums.max() ?? 0
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
        self.dataPoints.map(\.value).reduce(0, +)
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


// MARK: - Data Point
extension CTDataPointBaseProtocol  {
    
    /// Returns information about the data point for use in accessibility tags.
    func getCellAccessibilityValue(specifier: String) -> Text {
        Text(self.valueAsString(specifier: specifier) + ", " + self.wrappedDescription)
    }
}

extension CTDataPointBaseProtocol {
    /// Unwraps description
    public var wrappedDescription : String {
        self.description ?? ""
    }
}
extension CTStandardDataPointProtocol {
    /// Data point's value as a string
    public func valueAsString(specifier: String) -> String {
        if self.value != -Double.greatestFiniteMagnitude {
           return String(format: specifier, self.value)
        } else {
            return String("")
        }
    }
}
extension CTRangeDataPointProtocol {
    /// Data point's value as a string
    public func valueAsString(specifier: String) -> String {
        String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
    }
}
extension CTRangedLineDataPoint {
    /// Data point's value as a string
    public func valueAsString(specifier: String) -> String {
        String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
    }
}
