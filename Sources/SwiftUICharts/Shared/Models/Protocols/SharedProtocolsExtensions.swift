//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

extension CTChartData where Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count > 2
    }
}

extension CTChartData where Set: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: Bool = true
        dataSets.dataSets.forEach { dataSet in
            returnValue = dataSet.dataPoints.count > 2
        }
        return returnValue
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
    public func infoValue(info: DataPoint) -> some View {
        Text("\(info.valueAsString(specifier: self.infoView.touchSpecifier))")
    }
    public func infoUnit(info: DataPoint) -> some View {
        switch self.infoView.touchUnit {
        case .none:
            return Text("")
        case .prefix(of: let unit):
            return Text("\(unit)")
        case .suffix(of: let unit):
            return Text("\(unit)")
        }
    }
    public func infoDescription(info: DataPoint) -> some View {
        Text("\(info.wrappedDescription)")
    }
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

// MARK: - Data Set
extension CTSingleDataSetProtocol where Self.DataPoint: CTStandardDataPointProtocol & CTnotRanged {
    /**
     Returns the highest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Highest value in data set.
     */
    public func maxValue() -> Double  {
        return self.dataPoints.max { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the lowest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Lowest value in data set.
     */
    public func minValue() -> Double  {
        return self.dataPoints.min { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the average value from the data set.
     - Parameter dataSet: Target data set.
     - Returns: Average of values in data set.
     */
    public func average() -> Double {
        let sum = self.dataPoints.reduce(0) { $0 + $1.value }
        return sum / Double(self.dataPoints.count)
    }
    
}
extension CTSingleDataSetProtocol where Self.DataPoint: CTRangeDataPointProtocol & CTisRanged {
    /**
     Returns the highest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Highest value in data set.
     */
    public func maxValue() -> Double  {
        return self.dataPoints.max { $0.upperValue < $1.upperValue }?.upperValue ?? 0
    }
    
    /**
     Returns the lowest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Lowest value in data set.
     */
    public func minValue() -> Double  {
        return self.dataPoints.min { $0.lowerValue < $1.lowerValue }?.lowerValue ?? 0
    }
    
    /**
     Returns the average value from the data set.
     - Parameter dataSet: Target data set.
     - Returns: Average of values in data set.
     */
    public func average() -> Double {
        let sum = self.dataPoints.reduce(0) { $0 + ($1.upperValue - $1.lowerValue) }
        return sum / Double(self.dataPoints.count)
    }
    
}

extension CTMultiDataSetProtocol where Self.DataSet.DataPoint: CTStandardDataPointProtocol {
    /**
     Returns the highest value in the data sets
     - Parameter dataSet: Target data sets.
     - Returns: Highest value in data sets.
     */
    public func maxValue() -> Double {
        var setHolder : [Double] = []
        for set in self.dataSets {
            setHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.max { $0 < $1 } ?? 0
    }
    
    /**
     Returns the lowest value in the data sets.
     - Parameter dataSet: Target data sets.
     - Returns: Lowest value in data sets.
     */
    public func minValue() -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            setHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.min { $0 < $1 } ?? 0
    }
    
    /**
     Returns the average value from the data sets.
     - Parameter dataSet: Target data sets.
     - Returns: Average of values in data sets.
     */
    public func average() -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            let sum = set.dataPoints.reduce(0) { $0 + $1.value }
            setHolder.append(sum / Double(set.dataPoints.count))
        }
        let sum = setHolder.reduce(0) { $0 + $1 }
        return sum / Double(setHolder.count)
    }
}

// MARK: - Data Point
extension CTDataPointBaseProtocol  {
    func getCellAccessibilityValue(specifier: String) -> Text {
        Text(self.valueAsString(specifier: specifier) + ", " + self.wrappedDescription)
    }
}

extension CTDataPointBaseProtocol {
    public var wrappedDescription : String {
        self.description ?? ""
    }
}
extension CTStandardDataPointProtocol {
    public func valueAsString(specifier: String) -> String {
        String(format: specifier, self.value)
    }
}
extension CTRangeDataPointProtocol {
    public func valueAsString(specifier: String) -> String {
        String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
    }
}
extension CTRangedLineDataPoint {
    public func valueAsString(specifier: String) -> String {
        String(format: specifier, self.lowerValue) + "-" + String(format: specifier, self.upperValue)
    }
}
