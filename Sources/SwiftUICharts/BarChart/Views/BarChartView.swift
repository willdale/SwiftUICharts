//
//  BarChartView.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

public struct BarChart: View {
    public init() {}
    public var body: some View {
        BarChartView()
    }
}

internal struct BarChartView: View {
    
    @EnvironmentObject var chartData: ChartData
    
    internal var body: some View {
        
        let maxValue: Double    = chartData.maxValue()
        let style   : BarStyle  = chartData.barStyle
        
        return HStack(spacing: 0) {
            ForEach(chartData.dataPoints) { data in
                
                switch style.colourFrom {
                case .barStyle:
                    
                    if style.colourType == .colour,
                       let colour = style.colour
                    {
                        
                        ColourBar(colour: colour, data: data, maxValue: maxValue, style: style)
                        
                    } else if style.colourType == .gradientColour,
                              let colours    = style.colours,
                              let startPoint = style.startPoint,
                              let endPoint   = style.endPoint
                    {
                        
                        GradientColoursBar(colours: colours, startPoint: startPoint, endPoint: endPoint, data: data, maxValue: maxValue, style: style)
                        
                    } else if style.colourType == .gradientStops,
                              let stops      = style.stops,
                              let startPoint = style.startPoint,
                              let endPoint   = style.endPoint
                    {
                        
                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
                        GradientStopsBar(stops: safeStops, startPoint: startPoint, endPoint: endPoint, data: data, maxValue: maxValue, style: style)
                        
                    }
                    
                    
                case .dataPoints:
                    if data.colourType == .colour,
                       let colour = data.colour
                    {
                        ColourBar(colour: colour, data: data, maxValue: maxValue, style: style)
                    } else if data.colourType == .gradientColour,
                              let colours    = data.colours,
                              let startPoint = data.startPoint,
                              let endPoint   = data.endPoint
                    {

                        GradientColoursBar(colours: colours, startPoint: startPoint, endPoint: endPoint, data: data, maxValue: maxValue, style: style)


                    } else if data.colourType == .gradientStops,
                              let stops      = data.stops,
                              let startPoint = data.startPoint,
                              let endPoint   = data.endPoint
                    {

                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)

                        GradientStopsBar(stops: safeStops, startPoint: startPoint, endPoint: endPoint, data: data, maxValue: maxValue, style: style)
                    }
                }
            }
        }
        .onAppear() {
            chartData.viewData.chartType = .bar
        }
    }
    
}
