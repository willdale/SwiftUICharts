//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

/**
 View for drawing a line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 LineChart(chartData: data)
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
 .headerBox(chartData: data)
 .legends(chartData: data, columns: [GridItem(.flexible()), GridItem(.flexible())])
 ```
 */
public struct LineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let minValue : Double
    private let range    : Double
        
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue   = chartData.minValue
        self.range      = chartData.range
    }
     
    public var body: some View {
        
        if chartData.isGreaterThanTwo() {
            
            if chartData.dataSets.style.colourType == .colour,
               let colour = chartData.dataSets.style.colour
            {
                LineChartColourSubView(chartData: chartData,
                                       dataSet  : chartData.dataSets,
                                       minValue : minValue,
                                       range    : range,
                                       colour   : colour,
                                       isFilled : false)
                    .accessibility(label: Text("Line Chart"))
                
            } else if chartData.dataSets.style.colourType == .gradientColour,
                      let colours     = chartData.dataSets.style.colours,
                      let startPoint  = chartData.dataSets.style.startPoint,
                      let endPoint    = chartData.dataSets.style.endPoint
            {
                
                LineChartColoursSubView(chartData   : chartData,
                                        dataSet     : chartData.dataSets,
                                        minValue    : minValue,
                                        range       : range,
                                        colours     : colours,
                                        startPoint  : startPoint,
                                        endPoint    : endPoint,
                                        isFilled    : false)
                    .accessibility(label: Text("Line Chart"))
                
            } else if chartData.dataSets.style.colourType == .gradientStops,
                      let stops      = chartData.dataSets.style.stops,
                      let startPoint = chartData.dataSets.style.startPoint,
                      let endPoint   = chartData.dataSets.style.endPoint
            {
                let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                
                LineChartStopsSubView(chartData : chartData,
                                      dataSet   : chartData.dataSets,
                                      minValue  : minValue,
                                      range     : range,
                                      stops     : stops,
                                      startPoint: startPoint,
                                      endPoint  : endPoint,
                                      isFilled  : false)
                    .accessibility(label: Text("Line Chart"))
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
