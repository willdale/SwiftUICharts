//
//  MultiBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data set for a multi bar, bar charts.
 
 Contains information about each of bar sets within the chart.
 
 # Example
 ```
 let data = MultiBarDataSet(dataSets: [
     BarDataSet(dataPoints: [
                 BarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"  , colour: .blue),
                 BarChartDataPoint(value: 20, xAxisLabel: "1.2", pointLabel: "One Two"  , colour: .yellow),
                 BarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three", colour: .purple),
                 BarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four" , colour: .green)],
                legendTitle: "One",
                pointStyle: PointStyle(),
                style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
     BarDataSet(dataPoints: [
                 BarChartDataPoint(value: 50, xAxisLabel: "2.1", pointLabel: "Two One"  , colour: .blue),
                 BarChartDataPoint(value: 10, xAxisLabel: "2.2", pointLabel: "Two Two"  , colour: .yellow),
                 BarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .purple),
                 BarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .green)],
                legendTitle: "Two",
                pointStyle: PointStyle(),
                style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
     BarDataSet(dataPoints: [
                 BarChartDataPoint(value: 10, xAxisLabel: "3.1", pointLabel: "Three One"  , colour: .blue),
                 BarChartDataPoint(value: 50, xAxisLabel: "3.2", pointLabel: "Three Two"  , colour: .yellow),
                 BarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", colour: .purple),
                 BarChartDataPoint(value: 99, xAxisLabel: "3.4", pointLabel: "Three Four" , colour: .green)],
                legendTitle: "Three",
                pointStyle: PointStyle(),
                style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
     BarDataSet(dataPoints: [
                 BarChartDataPoint(value: 80, xAxisLabel: "4.1", pointLabel: "Four One"  , colour: .blue),
                 BarChartDataPoint(value: 10, xAxisLabel: "4.2", pointLabel: "Four Two"  , colour: .yellow),
                 BarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .purple),
                 BarChartDataPoint(value: 50, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .green)],
                legendTitle: "Four",
                style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints))
 ])
 ```
 
 # DataSet
 ```
 BarDataSet(dataPoints: [BarChartDataPoint],
            legendTitle: String,
            style: BarStyle)
 ```
 
 
 # BarChartDataPoint
 ```
 BarChartDataPoint(value: Double,
                   xAxisLabel: String?,
                   pointLabel: String?,
                   date: Date?)
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
 - [BarDataSet](x-source-tag://BarDataSet)
 - [BarChartDataPoint](x-source-tag://BarChartDataPoint)
 - [BarStyle](x-source-tag://BarStyle)
    - [CornerRadius](x-source-tag://CornerRadius)
    - [ColourFrom](x-source-tag://ColourFrom)
    - [GradientStop](x-source-tag://GradientStop)
 
 # Conforms to
 - MultiDataSet
 - DataSet
 - Hashable
 - Identifiable
 
 
 - Tag: MultiBarDataSet
 */
public struct MultiBarDataSet: MultiDataSet {
    
    public let id       : UUID
    public var dataSets : [BarDataSet]
    
    /// Initialises a new data set for Multiline Line Chart.
    public init(dataSets: [BarDataSet]) {
        self.id       = UUID()
        self.dataSets = dataSets
    }
}

