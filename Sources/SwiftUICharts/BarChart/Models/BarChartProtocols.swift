//
//  BarChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI


// MARK: - Chart Data
/**
 A protocol to extend functionality of `LineAndBarChartData` specifically for Bar Charts.
 
 # Reference
 [See LineAndBarChartData](x-source-tag://LineAndBarChartData)
 
 `LineAndBarChartData` conforms to [ChartData](x-source-tag://ChartData)
 
 - Tag: BarChartDataProtocol
 */
public protocol BarChartDataProtocol: LineAndBarChartData where CTStyle: CTBarChartStyle {
    var chartStyle  : CTStyle { get set }
}


extension LineAndBarChartData where Self: BarChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = self.getMaxValue()
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
    }
}


// MARK: - Style
/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Bar Charts.
 
 Currently empty.
 
 - Tag: CTBarChartStyle
 */
public protocol CTBarChartStyle : CTLineAndBarChartStyle {}

