//
//  MultiLineChart.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 View for drawing a multi-line, line chart.
 
 Uses `MultiLineChartData` data model.
 
 # Declaration
 
 ```
 MultiLineChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct MultiLineChart<ChartData>: View where ChartData: MultiLineChartData {
    
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation: Bool
    
    /// Initialises a multi-line, line chart.
    /// - Parameter chartData: Must be MultiLineChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                ZStack {
                    chartData.getAccessibility()
                    ForEach(chartData.dataSets.dataSets, id: \.id) { dataSet in
                        SingleLineChartSubView(chartData: chartData,
                                               dataSet: dataSet,
                                               colour: dataSet.style.lineColour)
                    }
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}

internal struct SingleLineChartSubView<ChartData>: View where ChartData: MultiLineChartData {
    @ObservedObject private var chartData: ChartData
    private let dataSet: LineDataSet
    private let colour: ChartColour
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataSet: LineDataSet,
        colour: ChartColour
    ) {
        self.chartData = chartData
        self.dataSet = dataSet
        self.colour = colour
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        LineShape(dataPoints: dataSet.dataPoints,
                  lineType: dataSet.style.lineType,
                  minValue: chartData.minValue,
                  range: chartData.range)
            .trim(to: startAnimation ? 1 : 0)
            .stroke(colour, strokeStyle: dataSet.style.strokeStyle)
        
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .background(Color(.gray).opacity(0.000000001))
            .onDisappear {
                self.startAnimation = false
            }
    }
}
