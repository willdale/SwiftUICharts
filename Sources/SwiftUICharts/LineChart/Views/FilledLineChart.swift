//
//  FilledLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 View for creating a filled line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 FilledLineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .pointMarkers(chartData: data)
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3,dash: [5,10]))
 .yAxisPOI(chartData: data,
           markerName: "50",
           markerValue: 50,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct FilledLineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    
    private let minValue: Double
    private let range: Double
    
    /// Initialises a filled line chart
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self.minValue = chartData.minValue
        self.range = chartData.range
        self.chartData.isFilled = true
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    if chartData.dataSets.style.lineColour.colourType == .colour,
                       let colour = chartData.dataSets.style.lineColour.colour
                    {
                        LineChartColourSubView(chartData: chartData,
                                               dataSet: chartData.dataSets,
                                               minValue: minValue,
                                               range: range,
                                               colour: colour,
                                               isFilled: true)
                    } else if chartData.dataSets.style.lineColour.colourType == .gradientColour,
                              let colours = chartData.dataSets.style.lineColour.colours,
                              let startPoint = chartData.dataSets.style.lineColour.startPoint,
                              let endPoint = chartData.dataSets.style.lineColour.endPoint
                    {
                        LineChartColoursSubView(chartData: chartData,
                                                dataSet: chartData.dataSets,
                                                minValue: minValue,
                                                range: range,
                                                colours: colours,
                                                startPoint: startPoint,
                                                endPoint: endPoint,
                                                isFilled: true)
                    } else if chartData.dataSets.style.lineColour.colourType == .gradientStops,
                              let stops = chartData.dataSets.style.lineColour.stops,
                              let startPoint = chartData.dataSets.style.lineColour.startPoint,
                              let endPoint = chartData.dataSets.style.lineColour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        LineChartStopsSubView(chartData: chartData,
                                              dataSet: chartData.dataSets,
                                              minValue: minValue,
                                              range: range,
                                              stops: stops,
                                              startPoint: startPoint,
                                              endPoint: endPoint,
                                              isFilled: true)
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
