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
    public func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}

// MARK: - Data Set
extension CTSingleDataSetProtocol where Self.DataPoint: CTStandardDataPointProtocol {
    /**
     Returns the highest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Highest value in data set.
     */
    func maxValue() -> Double  {
        return self.dataPoints.max { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the lowest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Lowest value in data set.
     */
    func minValue() -> Double  {
        return self.dataPoints.min { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the average value from the data set.
     - Parameter dataSet: Target data set.
     - Returns: Average of values in data set.
     */
    func average() -> Double {
        let sum = self.dataPoints.reduce(0) { $0 + $1.value }
        return sum / Double(self.dataPoints.count)
    }
    
}

extension CTMultiDataSetProtocol where Self.DataSet.DataPoint: CTStandardDataPointProtocol {
    /**
     Returns the highest value in the data sets
     - Parameter dataSet: Target data sets.
     - Returns: Highest value in data sets.
     */
    func maxValue() -> Double {
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
    func minValue() -> Double {
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
    func average() -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            let sum = set.dataPoints.reduce(0) { $0 + $1.value }
            setHolder.append(sum / Double(set.dataPoints.count))
        }
        let sum = setHolder.reduce(0) { $0 + $1 }
        return sum / Double(setHolder.count)
    }
}
