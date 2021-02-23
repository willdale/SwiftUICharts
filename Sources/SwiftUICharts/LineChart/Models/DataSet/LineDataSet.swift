//
//  LineDataSet.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a single line
 
 Contains information specific to each line within the chart .
 
 # Example
 ```
 LineDataSet(dataPoints: [
     LineChartDataPoint(value: 120, xAxisLabel: "M", pointLabel: "Monday"),
     LineChartDataPoint(value: 190, xAxisLabel: "T", pointLabel: "Tuesday"),
     LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
     LineChartDataPoint(value: 175, xAxisLabel: "T", pointLabel: "Thursday"),
     LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
     LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
     LineChartDataPoint(value: 190, xAxisLabel: "S", pointLabel: "Sunday")
 ],
 legendTitle: "Test One",
 pointStyle: PointStyle(),
 style: LineStyle(colour: Color.red, lineType: .curvedLine))
 ```
 */
public struct LineDataSet: CTLineChartDataSet {

    public let id           : UUID = UUID()
    public var dataPoints   : [LineChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : LineStyle
    
    
    /// Initialises a data set for a line in a Line Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be draw in.
    public init(dataPoints  : [LineChartDataPoint],
                legendTitle : String     = "",
                pointStyle  : PointStyle = PointStyle(),
                style       : LineStyle  = LineStyle()
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }
    
    public typealias ID      = UUID
    public typealias Styling = LineStyle
}
