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
    
    @EnvironmentObject public var stateObject: TestStateObject
    @EnvironmentObject public var chartData: ChartData
    
    public init() {}
    
    public var body: some View {
            ZStack {
                LineSubView(chartData: chartData)
            }
            .modifier(ChartSizeUpdating(stateObject: stateObject, chartData: chartData))
            .coordinateSpace(name: "Chart")
    }
}

internal struct LineSubView<ChartData>: View where ChartData: LineChartData {
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData
    ) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        LineShape(dataPoints: chartData.dataSets.dataPoints,
                  lineType: chartData.dataSets.style.lineType,
                  minValue: chartData.minValue,
                  range: chartData.range)
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.dataSets.style.lineColour, strokeStyle: chartData.dataSets.style.strokeStyle)
        
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}
