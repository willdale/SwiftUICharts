//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

public struct LineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject var chartData: ChartData
    
    private let minValue : Double
    private let range    : Double
    
    @State var startAnimation : Bool = false
    
    public init(chartData: ChartData) {
        self.chartData  = chartData
        self.minValue   = DataFunctions.minValue(dataPoints: chartData.dataSets.dataPoints)
        self.range      = DataFunctions.range(dataPoints: chartData.dataSets.dataPoints)
        
        setupLegends()
    }
    
    public var body: some View {
        
//        if chartData.isGreaterThanTwo {
        
        if chartData.dataSets.style.colourType == .colour,
           let colour = chartData.dataSets.style.colour
        {
            LineChartColourSubView(chartData: chartData,
                                   dataSet: chartData.dataSets,
                                   style: chartData.dataSets.style,
                                   minValue: minValue,
                                   range: range,
                                   colour: colour,
                                   isFilled: false)
            
        } else if chartData.dataSets.style.colourType == .gradientColour,
                  let colours     = chartData.dataSets.style.colours,
                  let startPoint  = chartData.dataSets.style.startPoint,
                  let endPoint    = chartData.dataSets.style.endPoint
        {

            LineChartColoursSubView(chartData: chartData,
                                    dataSet: chartData.dataSets,
                                    style: chartData.dataSets.style,
                                    minValue: minValue,
                                    range: range,
                                    colours: colours,
                                    startPoint: startPoint,
                                    endPoint: endPoint,
                                    isFilled: false)

        } else if chartData.dataSets.style.colourType == .gradientStops,
                  let stops      = chartData.dataSets.style.stops,
                  let startPoint = chartData.dataSets.style.startPoint,
                  let endPoint   = chartData.dataSets.style.endPoint
        {
            let stops = GradientStop.convertToGradientStopsArray(stops: stops)

            LineChartStopsSubView(chartData: chartData,
                                  dataSet: chartData.dataSets,
                                  style: chartData.dataSets.style,
                                  minValue: minValue,
                                  range: range,
                                  stops: stops,
                                  startPoint: startPoint,
                                  endPoint: endPoint,
                                  isFilled: false)
            
        }
//        } else { CustomNoDataView(chartData: chartData) }
    }
    internal mutating func setupLegends() {
        AddLegends.setupLine(chartData: &chartData, dataSet: chartData.dataSets)
    }
}


//internal struct LineShapeModifiers<T: LineAndBarChartData>: ViewModifier {
//    private let chartData : T
//
//    internal init(_ chartData : T) {
//        self.chartData  = chartData
//    }
//
//    func body(content: Content) -> some View {
//        content
//            .background(Color(.gray).opacity(0.01))
//            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
//            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }
//    }
//}
//
