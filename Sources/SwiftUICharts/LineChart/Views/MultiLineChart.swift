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

                let style : LineStyle = dataSet.style
                let strokeStyle = style.strokeStyle

//        if chartData.isGreaterThanTwo {

                if style.colourType == .colour,
                   let colour = style.colour
                {
                    LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(colour, style: Stroke.strokeToStrokeStyle(stroke: strokeStyle))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                
                } else if style.colourType == .gradientColour,
                          let colours     = style.colours,
                          let startPoint  = style.startPoint,
                          let endPoint    = style.endPoint
                {

                    LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: Stroke.strokeToStrokeStyle(stroke: strokeStyle))
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

                    LineShape(dataSet: dataSet, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                               startPoint: startPoint,
                                               endPoint: endPoint),
                                style: Stroke.strokeToStrokeStyle(stroke: strokeStyle))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                }
            }
        }
//        } else { CustomNoDataView(chartData: chartData) }
    }
    internal mutating func setupLegends() {
        for dataSet in chartData.dataSets.dataSets {
            LineLegends.setup(chartData: &chartData, dataSet: dataSet)
        }
    }
}
