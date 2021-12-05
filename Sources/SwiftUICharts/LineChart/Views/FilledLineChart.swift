//
//  FilledLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 View for creating a filled line chart.
 
 Uses `LineChartData` data model.
 
 # Declaration
 ```
 FilledLineChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct FilledLineChart<ChartData>: View where ChartData: FilledLineChartData {
    
    @ObservedObject private var chartData: ChartData
    
    private let minValue: Double
    private let range: Double
    
    @State private var startAnimation: Bool
    
    /// Initialises a filled line chart
    /// - Parameter chartData: Must be LineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self.minValue = chartData.minValue
        self.range = chartData.range
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    TopLineSubView(chartData: chartData,
                                   colour: chartData.dataSets.style.lineColour)
                    FilledLineSubView(chartData: chartData,
                                      colour: chartData.dataSets.style.lineColour)
                }
                // Needed for axes label frames
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

internal struct FilledLineSubView<ChartData>: View where ChartData: FilledLineChartData {
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
        FilledLine(dataPoints: chartData.dataSets.dataPoints,
                   lineType: chartData.dataSets.style.lineType,
                   minValue: chartData.minValue,
                   range: chartData.range)
            .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
            .fill(colour)
        
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}

internal struct TopLineSubView<ChartData>: View where ChartData: FilledLineChartData {
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
            .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
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

internal struct FilledLine<DataPoint>: Shape where DataPoint: CTStandardLineDataPoint & Ignorable {
    
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
            return Path.filledCurvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case .line:
            return Path.filledStraightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

extension Path {
    /// Draws straight lines between data points.
    static func filledStraightLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var lastIndex: Int = 0
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
                lastIndex = index
            }
            
            path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                     y: rect.height))
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            path.closeSubpath()
        }
        return path
    }
    
    /// Draws cubic Bézier curved lines between data points.
    static func filledCurvedLine<DataPoint>(
        rect: CGRect,
        dataPoints: [DataPoint],
        minValue: Double,
        range: Double
    ) -> Path where DataPoint: CTStandardLineDataPoint & Ignorable {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var lastIndex: Int = 0
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
            lastIndex = index
        }
        path.addLine(to: CGPoint(x: CGFloat(lastIndex) * x,
                                 y: rect.height))
        path.addLine(to: CGPoint(x: 0,
                                 y: rect.height))
        path.closeSubpath()
        return path
    }
}
