//
//  BarChart.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

/**
 View for creating a bar chart.
 
 Uses `BarChartData` data model.
 
 # Declaration

 ```
 BarChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 */
public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: 0) {
                    BarChartSubView(chartData: chartData)
                        .accessibilityLabel(chartData.accessibilityTitle)
                }
                .onAppear { // Needed for axes label frames
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}
