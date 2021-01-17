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
        let strokeStyle = style.strokeStyle
        
        if chartData.dataPoints.count > 2 {
            
            if style.colourType == .colour,
               let colour = style.colour
            {
                if !isFilled {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .stroke(colour, style: strokeStyle)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(colour)
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
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
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(LinearGradient(gradient: Gradient(colors: colours), startPoint: startPoint, endPoint: endPoint))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
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
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                } else {
                    LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(LinearGradient(gradient: Gradient(stops: stops),
                                             startPoint: startPoint,
                                             endPoint: endPoint))
                        .modifier(LineShapeModifiers(chartData))
                        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                            self.startAnimation = true
                        }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}

internal struct LineShapeModifiers: ViewModifier {
    
    private let chartData : ChartData
    
    
    internal init(_ chartData : ChartData) {
        self.chartData = chartData
    }
    
    func body(content: Content) -> some View {
        content
            .background(Color(.gray).opacity(0.01))
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder() }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder() }
            .onAppear(perform: setupLegends)
    }
    
    
    internal func setupLegends() {
        
        guard let lineLegend = chartData.metadata?.lineLegend else { return }
        let style : LineStyle = chartData.lineStyle
        
        if !chartData.legends.contains(where: { $0.legend == lineLegend }) { // init twice
            if style.colourType == .colour,
               let colour = style.colour
            {
                self.chartData.legends.append(LegendData(legend     : lineLegend,
                                                         colour     : colour,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity    : 1,
                                                         chartType  : .line))
            } else if style.colourType == .gradientColour,
                      let colours = style.colours
            {
                self.chartData.legends.append(LegendData(legend     : lineLegend,
                                                         colours    : colours,
                                                         startPoint : .leading,
                                                         endPoint   : .trailing,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity    : 1,
                                                         chartType  : .line))
            } else if style.colourType == .gradientStops,
                      let stops = style.stops
            {
                self.chartData.legends.append(LegendData(legend     : lineLegend,
                                                         stops      : stops,
                                                         startPoint : .leading,
                                                         endPoint   : .trailing,
                                                         strokeStyle: Stroke.strokeStyleToStroke(strokeStyle: style.strokeStyle),
                                                         prioity    : 1,
                                                         chartType  : .line))
            }
        }
        chartData.viewData.chartType = .line
    }
}
