//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

internal struct LineChartView: View {
    
    @EnvironmentObject var chartData: ChartData
    
    @State var startAnimation : Bool = false
    
    let isFilled : Bool
    
    internal init(isFilled : Bool) {
        self.isFilled = isFilled
    }
             
    internal var body: some View {

        let style : LineStyle = chartData.lineStyle
        let hasXAxisLabels  = chartData.viewData.hasXAxisLabels
        let hasYAxisLabels  = chartData.viewData.hasYAxisLabels
        
        
        let strokeStyle = style.strokeStyle
        
        
        if style.colourType == .colour,
           let colour = style.colour
        {
            if !isFilled {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(colour, style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            } else {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .fill(colour)
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            }
            
        } else if style.colourType == .gradientColour,
                  let colours     = style.colours,
                  let startPoint  = style.startPoint,
                  let endPoint    = style.endPoint
        {
            if !isFilled {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            } else {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .fill(LinearGradient(gradient: Gradient(colors: colours), startPoint: startPoint, endPoint: endPoint))
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            }
        } else if style.colourType == .gradientStops,
                  let stops      = style.stops,
                  let startPoint = style.startPoint,
                  let endPoint   = style.endPoint
        {
            let stops = GradientStop.convertToGradientStopsArray(stops: stops)
            if !isFilled {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            } else {
                 LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .trim(to: startAnimation ? 1 : 0)
                    .fill(LinearGradient(gradient: Gradient(stops: stops),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
                    .modifier(LineShapeModifiers(hasXAxisLabels, hasYAxisLabels))
                    .onAppear(perform: setupLegends)
                    .animateOnAppear(using: .linear(duration: 1.0)) {
                        self.startAnimation = true
                    }
            }
        }
    }
    
    internal func setupLegends() {
                
        guard let lineLegend = chartData.metadata?.lineLegend else { return }
        let style : LineStyle = chartData.lineStyle

        if !chartData.legends.contains(where: { $0.legend == lineLegend }) { // init twice
            if style.colourType == .colour,
               let colour = style.colour
            {
                self.chartData.legends.append(LegendData(legend: lineLegend,
                                                         colour: colour,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity: 1))
            } else if style.colourType == .gradientColour,
                      let colours = style.colours
            {
                self.chartData.legends.append(LegendData(legend: lineLegend,
                                                         colours: colours,
                                                         startPoint: .leading,
                                                         endPoint: .trailing,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity: 1))
            } else if style.colourType == .gradientStops,
                      let stops = style.stops
            {
                self.chartData.legends.append(LegendData(legend: lineLegend,
                                                         stops: stops,
                                                         startPoint: .leading,
                                                         endPoint: .trailing,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity: 1))
            }
        }
        chartData.viewData.chartType = .line
    }
}

internal struct LineShapeModifiers: ViewModifier {
    let hasXAxisLabels  : Bool
    let hasYAxisLabels  : Bool
    
    internal init(_ hasXAxisLabels  : Bool,
                  _ hasYAxisLabels  : Bool
    ) {
        self.hasXAxisLabels = hasXAxisLabels
        self.hasYAxisLabels = hasYAxisLabels
    }
    
    func body(content: Content) -> some View {
        content
            .background(Color(.systemGray).opacity(0.01))
            .if(hasXAxisLabels) { $0.xAxisBorder() }
            .if(hasYAxisLabels) { $0.yAxisBorder() }
    }
}
