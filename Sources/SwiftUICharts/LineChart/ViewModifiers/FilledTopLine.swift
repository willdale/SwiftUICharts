//
//  FilledTopLine.swift
//  
//
//  Created by Will Dale on 31/03/2021.
//

import SwiftUI

/**
 ViewModifier for for laying out point markers.
 */
internal struct FilledTopLine<T>: ViewModifier where T: LineChartData {
    
    @ObservedObject private var chartData: T
    private let lineColour: ColourStyle
    private let strokeStyle: StrokeStyle
    private let minValue: Double
    private let range: Double
    
    internal init(
        chartData: T,
        lineColour: ColourStyle,
        strokeStyle: StrokeStyle
    ) {
        self.chartData = chartData
        self.lineColour = lineColour
        self.strokeStyle = strokeStyle
        self.minValue = chartData.minValue
        self.range = chartData.range
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                if lineColour.colourType == .colour,
                   let colour = lineColour.colour
                {
                    LineShape(dataPoints: chartData.dataSets.dataPoints,
                              lineType: chartData.dataSets.style.lineType,
                              isFilled: false,
                              minValue: self.minValue,
                              range: self.range,
                              ignoreZero: chartData.dataSets.style.ignoreZero)
                        .scale(y: animationValue, anchor: .bottom)
                        .stroke(colour, style: strokeStyle)
                        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                } else if lineColour.colourType == .gradientColour,
                          let colours = lineColour.colours,
                          let startPoint = lineColour.startPoint,
                          let endPoint = lineColour.endPoint
                {
                    LineShape(dataPoints: chartData.dataSets.dataPoints,
                              lineType: chartData.dataSets.style.lineType,
                              isFilled: false,
                              minValue: self.minValue,
                              range: self.range,
                              ignoreZero: chartData.dataSets.style.ignoreZero)
                        .scale(y: animationValue, anchor: .bottom)
                        .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: strokeStyle)
                        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                } else if lineColour.colourType == .gradientStops,
                          let stops = lineColour.stops,
                          let startPoint = lineColour.startPoint,
                          let endPoint = lineColour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    LineShape(dataPoints: chartData.dataSets.dataPoints,
                              lineType: chartData.dataSets.style.lineType,
                              isFilled: false,
                              minValue: self.minValue,
                              range: self.range,
                              ignoreZero: chartData.dataSets.style.ignoreZero)
                        .scale(y: animationValue, anchor: .bottom)
                        .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: strokeStyle)
                        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = false
                        }
                }
                content
            } else { content }
        }
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
        }
    }
}

extension View {
    /**
     Adds an independent line on top of FilledLineChart.
     
     Allows for a hard line over the data point with a semi opaque fill.
     
     - Requires:
     Chart Data to conform to CTLineChartDataProtocol.
     - LineChartData
     
     # Available for:
     - Filled Line Chart
     
     # Unavailable for:
     - Line Chart
     - Multi Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
       - chartData: Chart data model.
       - lineColour: Line Colour
       - strokeStyle: Stroke Style
     - Returns: A  new view containing the chart with point markers.
     
     */
    public func filledTopLine<T: LineChartData>(
        chartData: T,
        lineColour: ColourStyle = ColourStyle(),
        strokeStyle: StrokeStyle = StrokeStyle()
    ) -> some View {
        self.modifier(FilledTopLine(chartData: chartData, lineColour: lineColour, strokeStyle: strokeStyle))
    }
}
