//
//  RangedLineChart.swift
//  
//
//  Created by Will Dale on 01/03/2021.
//

import SwiftUI

public struct RangedLineChart<ChartData>: View where ChartData: RangedLineChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be RangedLineChartData model.
    public init(chartData: ChartData) {
        self.chartData  = chartData
    }
    
    public var body: some View {
        
        if chartData.isGreaterThanTwo() {

            ZStack {

                chartData.getAccessibility()
                
                if chartData.dataSets.style.fillColour.colourType == .colour,
                   let colour = chartData.dataSets.style.fillColour.colour
                {
                    
                    RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                    lineType: chartData.dataSets.style.lineType,
                                    minValue: chartData.minValue,
                                    range: chartData.range)
                        .fill(colour)
                    
                    
                } else if chartData.dataSets.style.fillColour.colourType == .gradientColour,
                          let colours     = chartData.dataSets.style.fillColour.colours,
                          let startPoint  = chartData.dataSets.style.fillColour.startPoint,
                          let endPoint    = chartData.dataSets.style.fillColour.endPoint
                {
                    
                    RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                    lineType: chartData.dataSets.style.lineType,
                                    minValue: chartData.minValue,
                                    range: chartData.range)
                        .fill(LinearGradient(gradient: Gradient(colors: colours),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                    
                } else if chartData.dataSets.style.fillColour.colourType == .gradientStops,
                          let stops      = chartData.dataSets.style.fillColour.stops,
                          let startPoint = chartData.dataSets.style.fillColour.startPoint,
                          let endPoint   = chartData.dataSets.style.fillColour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    
                    RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                                    lineType: chartData.dataSets.style.lineType,
                                    minValue: chartData.minValue,
                                    range: chartData.range)
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                    
                }
                
                if chartData.dataSets.style.lineColour.colourType == .colour,
                   let colour = chartData.dataSets.style.lineColour.colour
                {

                    LineChartColourSubView(chartData: chartData,
                                           dataSet  : chartData.dataSets,
                                           minValue : chartData.minValue,
                                           range    : chartData.range,
                                           colour   : colour,
                                           isFilled : false)

                } else if chartData.dataSets.style.lineColour.colourType == .gradientColour,
                          let colours     = chartData.dataSets.style.lineColour.colours,
                          let startPoint  = chartData.dataSets.style.lineColour.startPoint,
                          let endPoint    = chartData.dataSets.style.lineColour.endPoint
                {

                    LineChartColoursSubView(chartData   : chartData,
                                            dataSet     : chartData.dataSets,
                                            minValue    : chartData.minValue,
                                            range       : chartData.range,
                                            colours     : colours,
                                            startPoint  : startPoint,
                                            endPoint    : endPoint,
                                            isFilled    : false)

                } else if chartData.dataSets.style.lineColour.colourType == .gradientStops,
                          let stops      = chartData.dataSets.style.lineColour.stops,
                          let startPoint = chartData.dataSets.style.lineColour.startPoint,
                          let endPoint   = chartData.dataSets.style.lineColour.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)

                    LineChartStopsSubView(chartData : chartData,
                                          dataSet   : chartData.dataSets,
                                          minValue  : chartData.minValue,
                                          range     : chartData.range,
                                          stops     : stops,
                                          startPoint: startPoint,
                                          endPoint  : endPoint,
                                          isFilled  : false)

                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}


/*
 
 ZStack {
     RangedLineFillShape(dataPoints: chartData.dataSets.dataPoints,
                     lineType: chartData.dataSets.style.lineType,
                     minValue: chartData.minValue,
                     range: chartData.range)
         .fill(Color.red.opacity(0.25))
   LineShape(dataPoints: chartData.dataSets.dataPoints,
             lineType: chartData.dataSets.style.lineType,
             isFilled: false,
             minValue: chartData.minValue,
             range: chartData.range)
       .stroke(Color.blue, lineWidth: 3)
 }
 */
