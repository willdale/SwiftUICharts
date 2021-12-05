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

internal struct LineSubView<ChartData>: View where ChartData: LineChartData {
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
        LineShape(dataPoints: chartData.dataSets.dataPoints,
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
