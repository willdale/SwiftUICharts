//
//  BarChartView.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject var chartData: ChartData
    
    let maxValue : Double
    
    public init(chartData: ChartData) {
        self.chartData = chartData
        
        self.maxValue = DataFunctions.dataSetMaxValue(from: chartData.dataSets)
        
        chartData.viewData.chartType = .bar
    }
    
    public var body: some View {
        
//        let maxValue: Double    = DataFunctions.maxValue(dataPoints: chartData.dataPoints)
//        let style   : BarStyle  = chartData.barStyle
        
        HStack(spacing: 0) {
            ForEach(chartData.dataSets, id: \.self) { dataSet in
                ForEach(dataSet.dataPoints, id: \.self) { dataPoint in
                    ColourBar(dataSet.style.colour!, dataPoint, maxValue, chartData.chartStyle, dataSet.style)
                }
            }
        }
    }
}



//                switch style.colourFrom {
//                case .barStyle:
//                    if style.colourType == .colour,
//                       let colour = style.colour
//                    {
//
//                        ColourBar(colour, data, maxValue, chartData.chartStyle, style)
//
//                    } else if style.colourType == .gradientColour,
//                              let colours    = style.colours,
//                              let startPoint = style.startPoint,
//                              let endPoint   = style.endPoint
//                    {
//
//                        GradientColoursBar(colours, startPoint, endPoint, data, maxValue, chartData.chartStyle, style)
//
//                    } else if style.colourType == .gradientStops,
//                              let stops      = style.stops,
//                              let startPoint = style.startPoint,
//                              let endPoint   = style.endPoint
//                    {
//
//                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
//                        GradientStopsBar(safeStops, startPoint, endPoint, data, maxValue, chartData.chartStyle, style)
//
//                    }
                    
                    
//                case .dataPoints:
//                    if data.colourType == .colour,
//                       let colour = data.colour
//                    {
//                        ColourBar(colour, data, maxValue, chartData.chartStyle, style)
//                    } else if data.colourType == .gradientColour,
//                              let colours    = data.colours,
//                              let startPoint = data.startPoint,
//                              let endPoint   = data.endPoint
//                    {
//
//                        GradientColoursBar(colours, startPoint, endPoint, data, maxValue, chartData.chartStyle, style)
//
//                    } else if data.colourType == .gradientStops,
//                              let stops      = data.stops,
//                              let startPoint = data.startPoint,
//                              let endPoint   = data.endPoint
//                    {
//
//                        let safeStops = GradientStop.convertToGradientStopsArray(stops: stops)
//
//                        GradientStopsBar(safeStops, startPoint, endPoint, data, maxValue, chartData.chartStyle, style)
//                    }
//                }


//        .onAppear {
//            chartData.viewData.chartType = .bar
//
//            guard let lineLegend = chartData.metadata?.lineLegend else { return }
//            let style : BarStyle = chartData.barStyle
//
//            if !chartData.legends.contains(where: { $0.legend == lineLegend }) { // init twice
//                if style.colourType == .colour,
//                   let colour = style.colour
//                {
//                    self.chartData.legends.append(LegendData(legend     : lineLegend,
//                                                             colour     : colour,
//                                                             strokeStyle: nil,
//                                                             prioity    : 1,
//                                                             chartType  : .bar))
//                } else if style.colourType == .gradientColour,
//                          let colours = style.colours
//                {
//                    self.chartData.legends.append(LegendData(legend     : lineLegend,
//                                                             colours    : colours,
//                                                             startPoint : .leading,
//                                                             endPoint   : .trailing,
//                                                             strokeStyle: nil,
//                                                             prioity    : 1,
//                                                             chartType  : .bar))
//                } else if style.colourType == .gradientStops,
//                          let stops = style.stops
//                {
//                    self.chartData.legends.append(LegendData(legend     : lineLegend,
//                                                             stops      : stops,
//                                                             startPoint : .leading,
//                                                             endPoint   : .trailing,
//                                                             strokeStyle: nil,
//                                                             prioity    : 1,
//                                                             chartType  : .bar))
//                }
//            }
//        }
