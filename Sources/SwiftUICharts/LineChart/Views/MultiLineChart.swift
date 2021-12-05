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
    
    private let minValue: Double
    private let range: Double
    
    @State private var startAnimation: Bool
    
    /// Initialises a multi-line, line chart.
    /// - Parameter chartData: Must be MultiLineChartData model.
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
                    ForEach(chartData.dataSets.dataSets, id: \.id) { dataSet in
                        LineChartSubView(chartData: chartData,
                                         dataSet: dataSet,
                                         minValue: minValue,
                                         range: range,
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
