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
    var barStyle    : BarStyle { get set }
    /**
     Data model conatining the style data for the chart.
     
     # Reference
     [CTChartStyle](x-source-tag://CTChartStyle)
     */
    var chartStyle  : CTStyle { get set }
}

//public protocol GroupedBarChartDataProtocol: BarChartDataProtocol {}




// MARK: - Style
/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Bar Charts.
 
 Currently empty.
 
 - Tag: CTBarChartStyle
 */
public protocol CTBarChartStyle: CTLineAndBarChartStyle {}







// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Standard Bar Charts.
 
 # Reference
 [See SingleDataSet](x-source-tag://SingleDataSet)
 
 - Tag: CTBarChartDataSet
 */
public protocol CTStandardBarChartDataSet: SingleDataSet {}

public protocol CTGroupedBarChartDataSet: SingleDataSet {}

public protocol CTSStackedBarChartDataSet: SingleDataSet {}








// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for standard Bar Charts.
  
 - Tag: CTStandardBarDataPoint
 */
public protocol CTBarDataPoint: CTLineAndBarDataPoint {}

/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for standard Bar Charts.
  
 - Tag: CTStandardBarDataPoint
 */
public protocol CTStandardBarDataPoint: CTBarDataPoint, CTColourStyle {}
/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for multi part Bar Charts.
 i.e: Grouped or Stacked
  
 - Tag: CTMultiPartBarDataPoint
 */
public protocol CTGroupedBarDataPoint: CTBarDataPoint, CTColourStyle {}
