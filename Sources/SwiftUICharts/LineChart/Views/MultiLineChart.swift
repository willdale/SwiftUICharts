//
//  MultiLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public struct MultiLineChart<ChartData>: View where ChartData: MultiLineChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let minValue : Double
    private let range    : Double

    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue   = chartData.getMinValue()
        self.range      = chartData.getRange()
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
