//
//  MultiLineDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data set for a multiple lines
 
 Contains information about each of lines within the chart.
 
 
 ```
 let data = MultiLineDataSet(dataSets: [
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
                                     LineChartDataPoint(value: 60,   xAxisLabel: "T", pointLabel: "Tuesday"),
                                     LineChartDataPoint(value: 120, xAxisLabel: "W", pointLabel: "Wednesday"),
                                     LineChartDataPoint(value: 85,  xAxisLabel: "T", pointLabel: "Thursday"),
                                     LineChartDataPoint(value: 140, xAxisLabel: "F", pointLabel: "Friday"),
                                     LineChartDataPoint(value: 80,  xAxisLabel: "S", pointLabel: "Saturday"),
                                     LineChartDataPoint(value: 50,   xAxisLabel: "S", pointLabel: "Sunday")
                                 ],
                                 legendTitle: "Test Two",
                                 pointStyle: PointStyle(),
                                 style: LineStyle(colour: Color.blue))])
 ```
 
 # DataSet
 ```
 LineDataSet(dataPoints: [LineChartDataPoint],
             legendTitle: String,
             pointStyle: PointStyle,
             style: LineStyle)
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
 - [LineDataSet](x-source-tag://LineDataSet)
 - [LineChartDataPoint](x-source-tag://LineChartDataPoint)
 - [PointStyle](x-source-tag://PointStyle)
    - [PointType](x-source-tag://PointType)
    - [PointShape](x-source-tag://PointShape)
 - [LineStyle](x-source-tag://LineStyle)
    - [ColourType](x-source-tag://ColourType)
    - [LineType](x-source-tag://LineType)
    - [GradientStop](x-source-tag://GradientStop)
 
 # Conforms to
 - MultiDataSet
 - DataSet
 - Hashable
 - Identifiable
 
 
 - Tag: MultiLineDataSet
 */
public struct MultiLineDataSet: MultiDataSet {
    
    public let id       : UUID
    
    public var dataSets : [LineDataSet]
    
    public init(dataSets: [LineDataSet]) {
        self.id       = UUID()
        self.dataSets = dataSets
    }
        
}

