//
//  MultiLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 View for drawing a multi-line, line chart.
 
 Uses `MultiLineChartData` data model.
 
 # Declaration
 ```
 MultiLineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .pointMarkers(chartData: data)
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
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
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct MultiLineChart<ChartData>: View where ChartData: MultiLineChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let minValue : Double
    private let range    : Double

    /// Initialises a multi-line, line chart.
    /// - Parameter chartData: Must be MultiLineChartData model.
    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue   = chartData.minValue
        self.range      = chartData.range
    }
    
    @State private var startAnimation : Bool = false
    
    public var body: some View {
        
        if chartData.isGreaterThanTwo() {
            
            ZStack {
                ForEach(chartData.dataSets.dataSets, id: \.id) { dataSet in
                    
                    if dataSet.style.colourType == .colour,
                       let colour = dataSet.style.colour
                    {
                        
                        LineChartColourSubView(chartData: chartData,
                                               dataSet: dataSet,
                                               minValue: minValue,
                                               range: range,
                                               colour: colour,
                                               isFilled: false)
                        
                    } else if dataSet.style.colourType == .gradientColour,
                              let colours     = dataSet.style.colours,
                              let startPoint  = dataSet.style.startPoint,
                              let endPoint    = dataSet.style.endPoint
                    {
                        
                        LineChartColoursSubView(chartData: chartData,
                                                dataSet: dataSet,
                                                minValue: minValue,
                                                range: range,
                                                colours: colours,
                                                startPoint: startPoint,
                                                endPoint: endPoint,
                                                isFilled: false)
                        
                    } else if dataSet.style.colourType == .gradientStops,
                              let stops      = dataSet.style.stops,
                              let startPoint = dataSet.style.startPoint,
                              let endPoint   = dataSet.style.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        
                        LineChartStopsSubView(chartData: chartData,
                                              dataSet: dataSet,
                                              minValue: minValue,
                                              range: range,
                                              stops: stops,
                                              startPoint: startPoint,
                                              endPoint: endPoint,
                                              isFilled: false)
                        
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
