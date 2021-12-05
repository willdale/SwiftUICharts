//
//  LineChartView.swift
//  LineChart
//
//  Created by Will Dale on 27/12/2020.
//

import SwiftUI

/**
 View for drawing a line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 
 ```
 LineChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct LineChart<ChartData>: View where ChartData: LineChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    LineSubView(chartData: chartData,
                                colour: chartData.dataSets.style.lineColour)
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

internal struct LineSubView<ChartData>: View where ChartData: CTLineChartDataProtocol & GetDataProtocol,
                                                   ChartData.SetType: CTLineChartDataSet,
                                                   ChartData.SetType.DataPoint: CTStandardLineDataPoint & Ignorable {
    @ObservedObject private var chartData: ChartData
    private let colour: ChartColour
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.colour = colour
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        Line(dataPoints: chartData.dataSets.dataPoints,
             lineType: chartData.dataSets.style.lineType,
             minValue: chartData.minValue,
             range: chartData.range)
            .trim(to: startAnimation ? 1 : 0)
            .stroke(colour, strokeStyle: chartData.dataSets.style.strokeStyle)
        
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}

internal struct Line<DataPoint>: Shape where DataPoint: CTStandardLineDataPoint & Ignorable {
    
    private let dataPoints: [DataPoint]
    private let lineType: LineType
    private let minValue: Double
    private let range: Double
    
    internal init(
        dataPoints: [DataPoint],
        lineType: LineType,
        minValue: Double,
        range: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.minValue = minValue
        self.range = range
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

extension Path {
    /// Draws straight lines between data points.
    internal static func straightLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        if dataPoints.count >= 2 {
            
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            
            for index in 1 ..< dataPoints.count {
                let datapoint = dataPoints[index]
                if datapoint.ignore { continue }
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    /// Draws cubic Bézier curved lines between data points.
    internal static func curvedLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPoint: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let datapoint = dataPoints[index]
            if datapoint.ignore { continue }
            
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(datapoint.value - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        return path
    }
}
