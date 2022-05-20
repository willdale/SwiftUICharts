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
 ```
 .pointMarkers(chartData: data)
 .touchOverlay(chartData: data, specifier: "%.0f")
 .yAxisPOI(chartData: data,
           markerName: "Something",
           markerValue: 110,
           labelPosition: .center(specifier: "%.0f"),
           labelColour: Color.white,
           labelBackground: Color.blue,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
 ```
 */
public struct RangedLineChart<ChartData>: View where ChartData: RangedLineChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    
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
                    if chartData.dataSets.style.fillColour.colourType == .colour,
                       let colour = chartData.dataSets.style.fillColour.colour
                    {
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                        .fill(colour)
                    } else if chartData.dataSets.style.fillColour.colourType == .gradientColour,
                              let colours = chartData.dataSets.style.fillColour.colours,
                              let startPoint = chartData.dataSets.style.fillColour.startPoint,
                              let endPoint = chartData.dataSets.style.fillColour.endPoint
                    {
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                    } else if chartData.dataSets.style.fillColour.colourType == .gradientStops,
                              let stops = chartData.dataSets.style.fillColour.stops,
                              let startPoint = chartData.dataSets.style.fillColour.startPoint,
                              let endPoint = chartData.dataSets.style.fillColour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                            lineType: chartData.dataSets.style.lineType,
                                            minValue: chartData.minValue,
                                            range: chartData.range,
                                            ignoreZero: chartData.dataSets.style.ignoreZero)
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                    }
                    
                    // MARK: Main Line
                    if chartData.dataSets.style.lineColour.colourType == .colour,
                       let colour = chartData.dataSets.style.lineColour.colour
                    {
                        LineChartColourSubView(chartData: chartData,
                                               dataSet: chartData.dataSets,
                                               minValue: chartData.minValue,
                                               range: chartData.range,
                                               colour: colour,
                                               isFilled: false)
                    } else if chartData.dataSets.style.lineColour.colourType == .gradientColour,
                              let colours = chartData.dataSets.style.lineColour.colours,
                              let startPoint = chartData.dataSets.style.lineColour.startPoint,
                              let endPoint = chartData.dataSets.style.lineColour.endPoint
                    {
                        LineChartColoursSubView(chartData: chartData,
                                                dataSet: chartData.dataSets,
                                                minValue: chartData.minValue,
                                                range: chartData.range,
                                                colours: colours,
                                                startPoint: startPoint,
                                                endPoint: endPoint,
                                                isFilled: false)
                    } else if chartData.dataSets.style.lineColour.colourType == .gradientStops,
                              let stops = chartData.dataSets.style.lineColour.stops,
                              let startPoint = chartData.dataSets.style.lineColour.startPoint,
                              let endPoint = chartData.dataSets.style.lineColour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        LineChartStopsSubView(chartData: chartData,
                                              dataSet: chartData.dataSets,
                                              minValue: chartData.minValue,
                                              range: chartData.range,
                                              stops: stops,
                                              startPoint: startPoint,
                                              endPoint: endPoint,
                                              isFilled: false)
                    }
                }
                // Needed for axes label frames
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
                .layoutNotifier(timer)
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}
