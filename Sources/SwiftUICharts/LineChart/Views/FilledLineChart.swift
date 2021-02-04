//
//  FilledLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public struct FilledLineChart<ChartData>: View where ChartData: LineChartData {

    @ObservedObject var chartData: ChartData

    private let minValue : Double
    private let range    : Double

    @State var startAnimation : Bool = false

    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue = chartData.getMinValue()
        self.range    = chartData.getRange()
        
        self.chartData.isFilled = true
    }
    
    public var body: some View {
                
//        if chartData.isGreaterThanTwo {
        
        if chartData.dataSets.style.colourType == .colour,
           let colour = chartData.dataSets.style.colour
        {
            
            LineChartColourSubView(chartData: chartData,
                                   dataSet: chartData.dataSets,
                                   minValue: minValue,
                                   range: range,
                                   colour: colour,
                                   isFilled: true)
            
        } else if chartData.dataSets.style.colourType == .gradientColour,
                  let colours     = chartData.dataSets.style.colours,
                  let startPoint  = chartData.dataSets.style.startPoint,
                  let endPoint    = chartData.dataSets.style.endPoint
        {
            
            LineChartColoursSubView(chartData: chartData,
                                    dataSet: chartData.dataSets,
                                    minValue: minValue,
                                    range: range,
                                    colours: colours,
                                    startPoint: startPoint,
                                    endPoint: endPoint,
                                    isFilled: true)
            
        } else if chartData.dataSets.style.colourType == .gradientStops,
                  let stops      = chartData.dataSets.style.stops,
                  let startPoint = chartData.dataSets.style.startPoint,
                  let endPoint   = chartData.dataSets.style.endPoint
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
//        } else { CustomNoDataView(chartData: chartData) }
    }
}
