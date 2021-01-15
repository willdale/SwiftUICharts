//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Configurable Point of interest
internal struct YAxisPOI: ViewModifier {
        
    @EnvironmentObject var chartData: ChartData
    
    private let markerName  : String
    private let markerValue : Double
    private let lineColour  : Color
    
    private let strokeStyle : StrokeStyle
    
    private let isAverage   : Bool
        
    internal init(markerName  : String,
                  markerValue : Double = 0,
                  lineColour  : Color,
                  strokeStyle : StrokeStyle,
                  
                  isAverage  : Bool
    ) {
        self.markerName  = markerName
        self.markerValue = markerValue
        self.lineColour  = lineColour
        
        self.strokeStyle = strokeStyle
        
        self.isAverage = isAverage
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            Marker(chartData: chartData, markerValue: markerValue, isAverage: isAverage, chartType: chartData.viewData.chartType)
                .stroke(lineColour, style: strokeStyle)
                .onAppear {
                    if !chartData.legends.contains(where: { $0.legend == markerName }) { // init twice
                        chartData.legends.append(LegendData(legend: markerName,
                                                            colour: lineColour,
                                                            strokeStyle : Stroke.strokeStyleToStroke(strokeStyle: strokeStyle),
                                                            prioity: 2))
                    }
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
    public func yAxisPOI(markerName  : String,
                         markerValue : Double,
                         lineColour  : Color        = Color(.systemBlue),
                         strokeStyle : StrokeStyle  = StrokeStyle(lineWidth: 2,
                                                                  lineCap: .round,
                                                                  lineJoin: .round,
                                                                  miterLimit: 10,
                                                                  dash: [CGFloat](),
                                                                  dashPhase: 0)

    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
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
    public func averageLine(markerName      : String        = "Average",
                            lineColour      : Color         = Color.primary,
                            strokeStyle     : StrokeStyle   = StrokeStyle(lineWidth: 2,
                                                                          lineCap: .round,
                                                                          lineJoin: .round,
                                                                          miterLimit: 10,
                                                                          dash: [CGFloat](),
                                                                          dashPhase: 0)
    ) -> some View {
        self.modifier(YAxisPOI(markerName   : markerName,
                               lineColour   : lineColour,
                               strokeStyle  : strokeStyle,
                               isAverage    : true))
    }
}
