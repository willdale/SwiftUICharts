//
//  LinearTrendLine.swift
//  
//
//  Created by Will Dale on 26/03/2021.
//

import SwiftUI

/**
 Draws a line across the chart to show the the trend in the data.
 */
internal struct LinearTrendLine<T>: ViewModifier where T: CTLineBarChartDataProtocol & GetDataProtocol {
    
    @ObservedObject private var chartData: T
    private let firstValue: Double
    private let lastValue: Double
    private let lineColour: ColourStyle
    private let strokeStyle: StrokeStyle
    
    init(
        chartData: T,
        firstValue: Double,
        lastValue: Double,
        lineColour: ColourStyle,
        strokeStyle: StrokeStyle
    ) {
        self.chartData = chartData
        self.firstValue = firstValue
        self.lastValue = lastValue
        self.lineColour = lineColour
        self.strokeStyle = strokeStyle
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            if lineColour.colourType == .colour,
               let colour = lineColour.colour
            {
                LinearTrendLineShape(firstValue: firstValue,
                                     lastValue: lastValue,
                                     range: chartData.range,
                                     minValue: chartData.minValue)
                    .stroke(colour, style: strokeStyle)
            } else if lineColour.colourType == .gradientColour,
                      let colours = lineColour.colours,
                      let startPoint = lineColour.startPoint,
                      let endPoint = lineColour.endPoint
            {
                LinearTrendLineShape(firstValue: firstValue,
                                     lastValue: lastValue,
                                     range: chartData.range,
                                     minValue: chartData.minValue)
                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
            } else if lineColour.colourType == .gradientStops,
                      let stops = lineColour.stops,
                      let startPoint = lineColour.startPoint,
                      let endPoint = lineColour.endPoint
            {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                LinearTrendLineShape(firstValue: firstValue,
                                     lastValue: lastValue,
                                     range: chartData.range,
                                     minValue: chartData.minValue)
                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
            }
        }
    }
}

extension View {
    /**
     Draws a line across the chart to show the the trend in the data.
     
     - Parameters:
        - chartData: Chart data model.
        - firstValue: The value of the leading data point.
        - lastValue: The value of the trailnig data point.
        - lineColour: Line Colour.
        - strokeStyle: Stroke Style.
     - Returns: A  new view containing the chart with a trend line.
     */
    public func linearTrendLine<T: CTLineBarChartDataProtocol & GetDataProtocol>(
        chartData: T,
        firstValue: Double,
        lastValue: Double,
        lineColour: ColourStyle = ColourStyle(),
        strokeStyle: StrokeStyle = StrokeStyle()
    ) -> some View {
        self.modifier(LinearTrendLine(chartData: chartData,
                                      firstValue: firstValue,
                                      lastValue: lastValue,
                                      lineColour: lineColour,
                                      strokeStyle: strokeStyle))
    }
}

