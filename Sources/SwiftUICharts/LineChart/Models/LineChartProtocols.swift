//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/**
 A protocol to extend functionality of `LineAndBarChartData` specifically for Line Charts.
 
 # Reference
 [See LineAndBarChartData](x-source-tag://LineAndBarChartData)
 
 `LineAndBarChartData` conforms to [ChartData](x-source-tag://ChartData)
 
 - Tag: LineChartDataProtocol
 */
public protocol LineChartDataProtocol: LineAndBarChartData where CTStyle: CTLineChartStyle {
    var chartStyle  : CTStyle { get set }
    var isFilled    : Bool { get set}
}

extension LineAndBarChartData where Self: LineChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double = self.getRange()
        let minValue    : Double = self.getMinValue()
        let range       : Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)

        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
}
extension LineAndBarChartData where Self: LineChartData {
    public func getRange() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.dataSetMaxValue(from: dataSets) - min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.dataSetMaxValue(from: dataSets)
        }
    }
    public func getMinValue() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
           return 0
        }
    }
}
extension LineAndBarChartData where Self: MultiLineChartData {
    public func getRange() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.multiDataSetMaxValue(from: dataSets) - min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.multiDataSetMaxValue(from: dataSets)
        }
    }
    public func getMinValue() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
           return 0
        }
    }
}

/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Line Charts.
 
 - Tag: CTLineChartStyle
 */
public protocol CTLineChartStyle : CTLineAndBarChartStyle {
    /**
     Where to start drawing the line chart from. Zero or data set minium.
     
     [See Baseline](x-source-tag://Baseline)
     */
    var baseline: Baseline { get set }
}
