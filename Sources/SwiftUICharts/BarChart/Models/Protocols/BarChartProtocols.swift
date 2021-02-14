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
    /**
     Data model conatining the style data for the chart.
     
     # Reference
     [CTChartStyle](x-source-tag://CTChartStyle)
     */
    var chartStyle  : CTStyle { get set }
}

// MARK: - Style
/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Bar Charts.
 
 Currently empty.
 
 - Tag: CTBarChartStyle
 */
public protocol CTBarChartStyle: CTLineAndBarChartStyle {}
