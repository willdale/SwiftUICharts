//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a standard bar chart.
 
 # Example
 ```
 let data = BarDataSet(dataPoints: [
     BarChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
     BarChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
     BarChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
     BarChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
     BarChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
     BarChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
     BarChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
 ],
 legendTitle: "Data",
 style      : BarStyle())
 ```
 
 # BarChartDataPoint
 ```
 BarChartDataPoint(value        : Double,
                   xAxisLabel   : String?,
                   pointLabel   : String?,
                   date         : Date?)
 ```
 
 # BarStyle
 ```
 BarStyle(barWidth     : CGFloat,
          cornerRadius : CornerRadius,
          colourFrom   : ColourFrom,
          ...)
 
 BarStyle(...
          colour: Color)
 
 BarStyle(...
          colours: [Color],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 
 BarStyle(...
          stops: [GradientStop],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 ```
 ---
 # Also See
 - [BarChartDataPoint](x-source-tag://BarChartDataPoint)
 - [BarStyle](x-source-tag://BarStyle)
    - [CornerRadius](x-source-tag://CornerRadius)
    - [ColourFrom](x-source-tag://ColourFrom)
    - [GradientStop](x-source-tag://GradientStop)
 
 # Conforms to
 - SingleDataSet
 - DataSet
 - Hashable
 - Identifiable
 
 - Tag: BarDataSet
 */
public struct BarDataSet: SingleDataSet {

    public let id           : UUID
    public var dataPoints   : [BarChartDataPoint]
    public var legendTitle  : String
    public var style        : BarStyle
    
    /// Initialises a new data set for a Bar Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    ///   - style: Styling for how the line will be drawin.
    public init(dataPoints  : [BarChartDataPoint],
                legendTitle : String,
                style       : BarStyle
    ) {
        self.id             = UUID()
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.style          = style
    }

    public typealias ID      = UUID
    public typealias Styling = BarStyle
}
