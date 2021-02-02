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
        let dataRange   : Double
        let minValue    : Double
        let range       : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            minValue  = self.getMinValue()
            dataRange = self.getRange()
            range     = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        case .zero:
            minValue  = 0
            dataRange = self.getMaxValue()
            range     = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        }
        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
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
