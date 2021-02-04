//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Configurable Point of interest
internal struct YAxisPOI<T>: ViewModifier where T: LineAndBarChartData {
        
    @ObservedObject var chartData: T
    
    private let markerName  : String
    private var markerValue : Double
    private let lineColour  : Color
    private let strokeStyle : StrokeStyle
    
    private let range       : Double
    private let minValue    : Double
    private let maxValue    : Double
        
    internal init(chartData   : T,
                  markerName  : String,
                  markerValue : Double = 0,
                  lineColour  : Color,
                  strokeStyle : StrokeStyle,
                  isAverage   : Bool
    ) {
        self.chartData   = chartData
        self.markerName  = markerName
        self.lineColour  = lineColour
        self.strokeStyle = strokeStyle
        
        self.markerValue = isAverage ? chartData.getAverage() : markerValue
        self.maxValue    = chartData.getMaxValue()
        self.range = chartData.getRange()
        self.minValue = chartData.getMinValue()
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
//            if chartData.isGreaterThanTwo {
            Marker(value        : markerValue,
                   range        : range,
                   minValue     : minValue,
                   maxValue     : maxValue,
                   chartType    : chartData.chartType.chartType)
                .stroke(lineColour, style: strokeStyle)
                .onAppear {
                    if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                        chartData.legends.append(LegendData(id          : UUID(),
                                                            legend      : markerName,
                                                            colour      : lineColour,
                                                            strokeStyle : Stroke.strokeStyleToStroke(strokeStyle: strokeStyle),
                                                            prioity     : 2,
                                                            chartType   : .line))
                    }
//                    }
            }
        }
    }
}

extension View {
    /**
     Horizontal line marking a custom value
     
     Shows a marker line at a specified value.
     
     # Example
     ```
     .yAxisPOI(chartData: data,
                  markerName: "Marker",
                  lineColour: .blue,
                  strokeStyle: StrokeStyle(lineWidth: 2,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           miterLimit: 10,
                                           dash: [8],
                                           dashPhase: 0))
     ```
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - markerValue: Value to mark
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at a specified value.
     
     - Tag: YAxisPOI
    */
    public func yAxisPOI<T:LineAndBarChartData>(chartData     : T,
                                                markerName    : String,
                                                markerValue   : Double,
                                                lineColour    : Color        = Color(.blue),
                                                strokeStyle   : StrokeStyle  = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData    : chartData,
                               markerName   : markerName,
                               markerValue  : markerValue,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : false))
    }
    
    
    /**
     Horizontal line marking the average
     
     Shows a marker line at the average of all the data points within
     the relevant data set(s).
     
     # Example
     ```
     .averageLine(chartData: data,
                  markerName: "Average",
                  lineColour: .primary,
                  strokeStyle: StrokeStyle(lineWidth: 2,
                                           lineCap: .round,
                                           lineJoin: .round,
                                           miterLimit: 10,
                                           dash: [8],
                                           dashPhase: 0))
     ```
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
        - chartData: Chart data model.
        - markerName: Title of marker, for the legend.
        - lineColour: Line Colour.
        - strokeStyle: Style of Stroke.
     - Returns: A  new view containing the chart with a marker line at the average.
     
    - Tag: AverageLine
    */
    public func averageLine<T:LineAndBarChartData>(chartData      : T,
                                                   markerName     : String        = "Average",
                                                   lineColour     : Color         = Color.primary,
                                                   strokeStyle    : StrokeStyle   = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, miterLimit: 10, dash: [CGFloat](), dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData    : chartData,
                               markerName   : markerName,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : true))
    }
}
