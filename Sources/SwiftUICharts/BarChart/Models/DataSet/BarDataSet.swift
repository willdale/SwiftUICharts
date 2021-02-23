//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a bar chart.
 
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
 legendTitle: "Data")
 ```
 */
public struct BarDataSet: CTStandardBarChartDataSet {

    public let id           : UUID = UUID()
    public var dataPoints   : [BarChartDataPoint]
    public var legendTitle  : String
    
    /// Initialises a new data set for a stabdard Bar Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    public init(dataPoints  : [BarChartDataPoint],
                legendTitle : String
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
    }

    public typealias ID        = UUID
    public typealias DataPoint = BarChartDataPoint
}
