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
        
        let style : LineStyle = chartData.dataSets.style
        let strokeStyle = style.strokeStyle
        
//        if chartData.isGreaterThanTwo {
        
        if style.colourType == .colour,
           let colour = style.colour
        {
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
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
            
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
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
            
            LineShape(dataSet: chartData.dataSets, lineType: style.lineType, isFilled: false, minValue: minValue, range: range)
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
//        } else { CustomNoDataView(chartData: chartData) }
    }
    internal mutating func setupLegends() {
        LineLegends.setup(chartData: &chartData, dataSet: chartData.dataSets)
    }
}





internal struct LineShapeModifiers<T: ChartData>: ViewModifier {
    private let chartData : T

    internal init(_ chartData : T) {
        self.chartData  = chartData
    }

    func body(content: Content) -> some View {
        content
            .background(Color(.gray).opacity(0.01))
            .if(chartData.viewData.hasXAxisLabels) { $0.xAxisBorder(chartData: chartData) }
            .if(chartData.viewData.hasYAxisLabels) { $0.yAxisBorder(chartData: chartData) }
    }
}

struct LineLegends {
    static func setup<T: ChartData>(chartData: inout T, dataSet: LineDataSet) {
        if dataSet.style.colourType == .colour,
           let colour = dataSet.style.colour
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                colour     : colour,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
            
        } else if dataSet.style.colourType == .gradientColour,
                  let colours = dataSet.style.colours
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                colours    : colours,
                                                startPoint : .leading,
                                                endPoint   : .trailing,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
            
        } else if dataSet.style.colourType == .gradientStops,
                  let stops = dataSet.style.stops
        {
            chartData.legends.append(LegendData(legend     : dataSet.legendTitle,
                                                stops      : stops,
                                                startPoint : .leading,
                                                endPoint   : .trailing,
                                                strokeStyle: dataSet.style.strokeStyle,
                                                prioity    : 1,
                                                chartType  : .line))
        }
        chartData.viewData.chartType = .line
    }
}
