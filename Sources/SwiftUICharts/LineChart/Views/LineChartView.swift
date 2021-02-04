//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

/**
 View for drawing a line graph.
 
 This creates a single line, line chart.
 
 # Example
 ## Data Initialisation
 ```
 let data : LineChartData = makeData()
 ```
 ## Declaration
 ```
 LineChart(chartData: data)
 ```
 
 ## View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
    .touchOverlay(chartData: data)
    .pointMarkers(chartData: data)
    .averageLine(chartData: data)
    .yAxisPOI(chartData: data)
    .xAxisGrid(chartData: data)
    .yAxisGrid(chartData: data)
    .xAxisLabels(chartData: data)
    .yAxisLabels(chartData: data)
    .headerBox(chartData: data)
    .legends(chartData: data)
 ```
 - [Touch Overlay](x-source-tag://TouchOverlay)
 - [Point Markers](x-source-tag://PointMarkers)
 - [Average Line](x-source-tag://AverageLine)
 - [Y Axis POI](x-source-tag://YAxisPOI)
 - [X Axis Grid](x-source-tag://XAxisGrid)
 - [Y Axis Grid](x-source-tag://YAxisGrid)
 - [X Axis Labels](x-source-tag://XAxisLabels)
 - [Y Axis Labels](x-source-tag://YAxisLabels)
 - [Header Box](x-source-tag://HeaderBox)
 - [Legends](x-source-tag://Legends)
 
 ## Data Model
 `LineChartData` is the central model
 ```
 static func makeData() -> LineChartData {
     
     let data = LineDataSet(dataPoints: [
         LineChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
         LineChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
         LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
         LineChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
         LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
         LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
         LineChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
     ],
     legendTitle: "Data",
     pointStyle: PointStyle(),
     style: LineStyle()
     
     let metadata = ChartMetadata(title: "Some Data", subtitle: "A Week")
     
     let labels = ["Monday", "Thursday", "Sunday"]
     
     return LineChartData(dataSets: data,
                          metadata: metadata,
                          xAxisLabels: labels,
                          chartStyle: LineChartStyle(),
                          calculations: .none)
 }
 
 ```
 
 ---
 
 # Also See
 - [LineDataSet](x-source-tag://LineDataSet)
 - [ChartMetadata](x-source-tag://ChartMetadata)
 - [LineChartStyle](x-source-tag://LineChartStyle)

 # Conforms to
 - View
 
 - Tag: ChartData
 */
public struct LineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let minValue : Double
    private let range    : Double
        
    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue = chartData.getMinValue()
        self.range    = chartData.getRange()
    }
     
    public var body: some View {
        
//        if chartData.isGreaterThanTwo {
        
        if chartData.dataSets.style.colourType == .colour,
           let colour = chartData.dataSets.style.colour
        {
            LineChartColourSubView(chartData: chartData,
                                   dataSet  : chartData.dataSets,
                                   minValue : minValue,
                                   range    : range,
                                   colour   : colour,
                                   isFilled : false)
            
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
            
        }
//        } else { CustomNoDataView(chartData: chartData) }
    }
}
