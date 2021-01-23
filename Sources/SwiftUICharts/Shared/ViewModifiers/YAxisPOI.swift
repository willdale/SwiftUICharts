//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Configurable Point of interest
internal struct YAxisPOI<T>: ViewModifier where T: ChartData {
        
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
        self.markerValue = markerValue
        self.lineColour  = lineColour
        self.strokeStyle = strokeStyle
        
        self.markerValue = isAverage ? DataFunctions.dataSetAverage(from: chartData.dataSets) : markerValue
        //Line
        self.range    = DataFunctions.dataSetRange(from: chartData.dataSets)
        self.minValue = DataFunctions.dataSetMinValue(from: chartData.dataSets)
        
        
        // Bar
        /*
         
         
         THIS WILL NEED FIXING !!!!
         
         
         */
        self.maxValue = DataFunctions.maxValue(dataPoints: chartData.dataSets[0].dataPoints)
        
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
//            if chartData.isGreaterThanTwo {
            Marker(value        : markerValue,
                   range        : range,
                   minValue     : minValue,
                   maxValue     : maxValue,
                   chartType    : chartData.viewData.chartType)
                .stroke(lineColour, style: strokeStyle)
                .onAppear {
                    if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                        chartData.legends.append(LegendData(legend      : markerName,
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
    /// Shows a marker line at chosen point.
    /// - Parameters:
    ///   - markerName: Title of marker, for the legend
    ///   - markerValue : Chosen point.
    ///   - lineColour: Line Colour
    ///   - strokeStyle: Style of Stroke
    /// - Returns: A marker line at the average of all the data points.
    public func yAxisPOI<T:ChartData>(chartData     : T,
                                      markerName    : String,
                                      markerValue   : Double,
                                      lineColour    : Color        = Color(.blue),
                                      strokeStyle   : StrokeStyle  = StrokeStyle(lineWidth: 2,
                                                                                 lineCap: .round,
                                                                                 lineJoin: .round,
                                                                                 miterLimit: 10,
                                                                                 dash: [CGFloat](),
                                                                                 dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData    : chartData,
                               markerName   : markerName,
                               markerValue  : markerValue,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : false))
    }
    
    
    /// Shows a marker line at the average of all the data points.
    /// - Parameters:
    ///   - markerName: Title of marker, for the legend
    ///   - lineColour: Line Colour
    ///   - strokeStyle: Style of Stroke
    /// - Returns: A marker line at the average of all the data points.
    public func averageLine<T:ChartData>(chartData      : T,
                                         markerName     : String        = "Average",
                                         lineColour     : Color         = Color.primary,
                                         strokeStyle    : StrokeStyle   = StrokeStyle(lineWidth: 2,
                                                                                      lineCap: .round,
                                                                                      lineJoin: .round,
                                                                                      miterLimit: 10,
                                                                                      dash: [CGFloat](),
                                                                                      dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(chartData    : chartData,
                               markerName   : markerName,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : true))
    }
}
