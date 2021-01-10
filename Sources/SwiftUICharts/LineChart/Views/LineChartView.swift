//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

internal struct LineChartView: View {
    
    @EnvironmentObject var chartData: ChartData
    
    let isFilled : Bool
    
    init(isFilled : Bool) {
        self.isFilled = isFilled
    }
                    
    internal var body: some View {
        
        let style = chartData.chartStyle
        let hasXAxisLabels = chartData.viewData.hasXAxisLabels
        let strokeStyle = StrokeStyle(lineWidth    : style.lineWidth,
                                      lineCap      : style.lineCap,
                                      lineJoin     : style.lineJoin,
                                      miterLimit   : style.miterLimit)
        
        if style.styleType == .colour,
           let colour = style.colour
        {
            if !isFilled {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .stroke(colour, style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            } else {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .fill(colour)
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            }
            
        } else if style.styleType == .gradientColour,
                  let colours     = chartData.chartStyle.colours,
                  let startPoint  = chartData.chartStyle.startPoint,
                  let endPoint    = chartData.chartStyle.endPoint
        {
            if !isFilled {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            } else {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .fill(LinearGradient(gradient: Gradient(colors: colours), startPoint: startPoint, endPoint: endPoint))
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            }
        } else if style.styleType == .gradientColour,
                  let stops      = chartData.chartStyle.stops,
                  let startPoint = chartData.chartStyle.startPoint,
                  let endPoint   = chartData.chartStyle.endPoint
        {
            let stops = GradientStop.convertToGradientStopsArray(stops: stops)
            if !isFilled {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                           startPoint: startPoint,
                                           endPoint: endPoint),
                            style: strokeStyle)
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            } else {
                LineShape(chartData: chartData, lineType: style.lineType, isFilled: isFilled)
                    .fill(LinearGradient(gradient: Gradient(stops: stops),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
                    .modifier(LineShapeModifiers(hasXAxisLabels: hasXAxisLabels))
                    .onAppear(perform: setupLegends)
            }
        }
    }
    
    internal func setupLegends() {
        let styleType   = chartData.chartStyle.styleType
        let chartStyle  = chartData.chartStyle
        guard let lineLegend = chartData.metadata?.lineLegend else { return }
        
        if !chartData.legends.contains(where: { $0.legend == lineLegend }) { // init twice
            if styleType == .colour,
               let colour = chartStyle.colour
            {
                self.chartData.legends.append(LegendData(legend: lineLegend, colour: colour))
            } else if styleType == .gradientColour,
                      let colours = chartData.chartStyle.colours
            {
                self.chartData.legends.append(LegendData(legend: lineLegend,
                                                         colours: colours,
                                                         startPoint: .leading,
                                                         endPoint: .trailing))
            } else if styleType == .gradientStops,
                      let stops = chartData.chartStyle.stops
            {
                self.chartData.legends.append(LegendData(legend: lineLegend,
                                                         stops: stops,
                                                         startPoint: .leading,
                                                         endPoint: .trailing))
            }
        }
    }
}

internal struct LineShapeModifiers: ViewModifier {
    let hasXAxisLabels: Bool
    func body(content: Content) -> some View {
        content
            .background(Color(.systemGray).opacity(0.01))
            .if(hasXAxisLabels) { $0.xAxisBorder() }
            .if(hasXAxisLabels) { $0.yAxisBorder() }
    }
}
