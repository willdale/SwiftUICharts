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
 let data = LineDataSet(dataPoints: [
     LineChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
     LineChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
     LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
     LineChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
     LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
     LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
     LineChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
 ],
 legendTitle: "Data",
 pointStyle: PointStyle(),
 style: LineStyle())
 ```
 
 # LineChartDataPoint
 ```
 LineChartDataPoint(value: Double,
                    xAxisLabel: String?,
                    pointLabel: String?,
                    date: Date?)
 ```
 
 # PointStyle
 ```
 PointStyle(pointSize: CGFloat,
            borderColour: Color,
            fillColour: Color,
            lineWidth: CGFloat,
            pointType: PointType,
            pointShape: PointShape)
 ```
 
 # LineStyle
 ```
 LineStyle(colour: Color,
           ...)
 
 LineStyle(colours: [Color],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(stops: [GradientStop],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(...,
           lineType: LineType,
           strokeStyle: Stroke,
           ignoreZero: Bool)
 ```
 ---
 # Also See
 - [LineChartDataPoint](x-source-tag://LineChartDataPoint)
 - [PointStyle](x-source-tag://PointStyle)
    - [PointType](x-source-tag://PointType)
    - [PointShape](x-source-tag://PointShape)
 - [LineStyle](x-source-tag://LineStyle)
    - [ColourType](x-source-tag://ColourType)
    - [LineType](x-source-tag://LineType)
    - [GradientStop](x-source-tag://GradientStop)
 
 # Conforms to
 - SingleDataSet
 - DataSet
 - Hashable
 - Identifiable
 
 - Tag: LineDataSet
 */
public struct LineDataSet: CTLineChartDataSet {

    public let id           : UUID
    public var dataPoints   : [LineChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : LineStyle
    
    
    /// Initialises a new data set for Line Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be drawin.
    public init(dataPoints  : [LineChartDataPoint],
                legendTitle : String     = "",
                pointStyle  : PointStyle = PointStyle(),
                style       : LineStyle  = LineStyle()
    ) {
        self.id             = UUID()
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }
    
    public typealias ID      = UUID
    public typealias Styling = LineStyle
}
