//
//  RangedLineDataSet.swift
//  
//
//  Created by Will Dale on 02/03/2021.
//

import SwiftUI

/**
 Data set for a ranged line.
 
 Contains information specific to the line and range fill.
 
 # Example
 ```
 RangedLineDataSet(dataPoints: [
     RangedLineChartDataPoint(value: 10, upperValue: 20, lowerValue: 0 , xAxisLabel: "M", pointLabel: "Monday"),
     RangedLineChartDataPoint(value: 25, upperValue: 35, lowerValue: 15, xAxisLabel: "T", pointLabel: "Tuesday"),
     RangedLineChartDataPoint(value: 13, upperValue: 23, lowerValue: 3 , xAxisLabel: "W", pointLabel: "Wednesday"),
     RangedLineChartDataPoint(value: 24, upperValue: 34, lowerValue: 14, xAxisLabel: "T", pointLabel: "Thursday"),
     RangedLineChartDataPoint(value: 36, upperValue: 46, lowerValue: 26, xAxisLabel: "F", pointLabel: "Friday"),
     RangedLineChartDataPoint(value: 14, upperValue: 24, lowerValue: 4 , xAxisLabel: "S", pointLabel: "Saturday"),
     RangedLineChartDataPoint(value: 20, upperValue: 30, lowerValue: 10, xAxisLabel: "S", pointLabel: "Sunday")
 ],
 legendTitle: "Steps",
 pointStyle: PointStyle(),
 style: RangedLineStyle(lineColour: ColourStyle(colour: .red),
                        fillColour: ColourStyle(colour: Color(.blue).opacity(0.25)),
                        lineType: .curvedLine))
 ```
 */
public struct RangedLineDataSet: CTLineChartDataSet {

    public let id           : UUID = UUID()
    public var dataPoints   : [RangedLineChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : RangedLineStyle


    /// Initialises a data set for a line in a Line Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be draw in.
    public init(dataPoints  : [RangedLineChartDataPoint],
                legendTitle : String          = "",
                pointStyle  : PointStyle      = PointStyle(),
                style       : RangedLineStyle = RangedLineStyle()
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }

    public typealias ID      = UUID
    public typealias Styling = RangedLineStyle

}
