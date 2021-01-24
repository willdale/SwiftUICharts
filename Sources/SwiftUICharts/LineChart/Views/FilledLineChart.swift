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
        self.minValue   = DataFunctions.minValue(dataPoints: chartData.dataSets.dataPoints)
        self.range      = DataFunctions.range(dataPoints: chartData.dataSets.dataPoints)
    }
    
    public var body: some View {
        
        let style : LineStyle = chartData.dataSets.style
        
//        if chartData.isGreaterThanTwo {
        
        if style.colourType == .colour,
           let colour = style.colour
        {
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: true, minValue: minValue, range: range)
                .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                .fill(colour)
                .modifier(LineShapeModifiers(chartData))
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
        } else if style.colourType == .gradientColour,
                  let colours     = style.colours,
                  let startPoint  = style.startPoint,
                  let endPoint    = style.endPoint
        {
            
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: true, minValue: minValue, range: range)
                .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                .fill(LinearGradient(gradient: Gradient(colors: colours),
                                     startPoint: startPoint,
                                     endPoint: endPoint))
                .modifier(LineShapeModifiers(chartData))
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
            
        } else if style.colourType == .gradientStops,
                  let stops      = style.stops,
                  let startPoint = style.startPoint,
                  let endPoint   = style.endPoint
        {
            let stops = GradientStop.convertToGradientStopsArray(stops: stops)
            
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: true, minValue: minValue, range: range)
                .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                .fill(LinearGradient(gradient: Gradient(stops: stops),
                                       startPoint: startPoint,
                                       endPoint: endPoint))
                .modifier(LineShapeModifiers(chartData))
                .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                    self.startAnimation = true
                }
        }
//        } else { CustomNoDataView(chartData: chartData) }
    }
    internal mutating func setupLegends() {
        LineLegends.setup(chartData: &chartData, dataSet: chartData.dataSets)
    }
}
