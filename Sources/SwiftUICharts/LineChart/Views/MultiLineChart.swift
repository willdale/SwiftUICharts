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
    
    @State var startAnimation : Bool = false

    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue   = DataFunctions.multiDataSetMinValue(from: chartData.dataSets)
        self.range      = DataFunctions.multiDataSetRange(from: chartData.dataSets)

        setupLegends()
    }
    
    public var body: some View {
        
        ZStack {
            ForEach(chartData.dataSets.dataSets, id: \.self) { dataSet in

//        if chartData.isGreaterThanTwo {

                if dataSet.style.colourType == .colour,
                   let colour = dataSet.style.colour
                {
                    
                    LineChartColourSubView(chartData: chartData, dataSet: dataSet, style: dataSet.style, minValue: minValue, range: range, colour: colour, isFilled: false)

                } else if dataSet.style.colourType == .gradientColour,
                          let colours     = dataSet.style.colours,
                          let startPoint  = dataSet.style.startPoint,
                          let endPoint    = dataSet.style.endPoint
                {
                    
                    LineChartColoursSubView(chartData: chartData, dataSet: dataSet, style: dataSet.style, minValue: minValue, range: range, colours: colours, startPoint: startPoint, endPoint: endPoint, isFilled: false)
                           
                } else if dataSet.style.colourType == .gradientStops,
                          let stops      = dataSet.style.stops,
                          let startPoint = dataSet.style.startPoint,
                          let endPoint   = dataSet.style.endPoint
                {
                    let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                    
                    LineChartStopsSubView(chartData: chartData, dataSet: dataSet, style: dataSet.style, minValue: minValue, range: range, stops: stops, startPoint: startPoint, endPoint: endPoint, isFilled: false)
                    
                }
            }
        }
//        } else { CustomNoDataView(chartData: chartData) }
    }
    internal mutating func setupLegends() {
        for dataSet in chartData.dataSets.dataSets {
            AddLegends.setupLine(chartData: &chartData, dataSet: dataSet)
        }
    }
}
