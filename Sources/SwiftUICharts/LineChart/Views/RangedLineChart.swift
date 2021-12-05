//
//  RangedLineChart.swift
//  
//
//  Created by Will Dale on 01/03/2021.
//

import SwiftUI

/**
 View for drawing a line chart with upper and lower range values .
 
 Uses `RangedLineChartData` data model.
 
 # Declaration
 
 ```
 RangedLineChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct RangedLineChart<ChartData>: View where ChartData: RangedLineChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be RangedLineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    // MARK: Ranged Box
                    switch chartData.dataSets.style.lineColour {
                    case let .colour(colour):
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                            .fill(colour)
                    case let .gradient(colours, startPoint, endPoint):
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                            .fill(LinearGradient(gradient: Gradient(colors: colours),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                    case let .gradientStops(stops, startPoint, endPoint):
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                            .fill(LinearGradient(gradient: Gradient(stops: stops.convert),
                                                 startPoint: startPoint,
                                                 endPoint: endPoint))
                    }
                    
                    // MARK: Main Line
                    LineChartSubView(chartData: chartData,
                                     dataSet: chartData.dataSets,
                                     minValue: chartData.minValue,
                                     range: chartData.range,
                                     colour: chartData.dataSets.style.lineColour)
                }
                // Needed for axes label frames
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}
