//
//  MultiLineDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data set containing multiple data sets for multiple lines
 
 Contains information about each of lines within the chart.
 
 # Example
 ```
MultiLineDataSet(dataSets: [
      LineDataSet(dataPoints: [
          LineChartDataPoint(value: 60,  xAxisLabel: "M", pointLabel: "Monday"),
          LineChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
          LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
          LineChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
          LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
          LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
          LineChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
      ],
      legendTitle: "Test One",
      pointStyle: PointStyle(),
      style: LineStyle(colour: Color.red)),
      LineDataSet(dataPoints: [
          LineChartDataPoint(value: 90,  xAxisLabel: "M", pointLabel: "Monday"),
          LineChartDataPoint(value: 60,  xAxisLabel: "T", pointLabel: "Tuesday"),
          LineChartDataPoint(value: 120, xAxisLabel: "W", pointLabel: "Wednesday"),
          LineChartDataPoint(value: 85,  xAxisLabel: "T", pointLabel: "Thursday"),
          LineChartDataPoint(value: 140, xAxisLabel: "F", pointLabel: "Friday"),
          LineChartDataPoint(value: 80,  xAxisLabel: "S", pointLabel: "Saturday"),
          LineChartDataPoint(value: 50,  xAxisLabel: "S", pointLabel: "Sunday")
      ],
      legendTitle: "Test Two",
      pointStyle: PointStyle(),
      style: LineStyle(colour: Color.blue))
 ])
 ```
 */
public struct MultiLineDataSet: CTMultiLineChartDataSet {
    
    public let id       : UUID = UUID()
    public var dataSets : [LineDataSet]
    
    /// Initialises a new data set for multi-line Line Charts.
    public init(dataSets: [LineDataSet]) {
        self.dataSets = dataSets
    }
}

