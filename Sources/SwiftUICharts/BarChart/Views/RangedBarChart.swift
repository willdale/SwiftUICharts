//
//  RangedBarChart.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 View for creating a grouped bar chart.
 
 Uses `RangedBarChartData` data model.
 
 # Declaration
 
 ```
 RangedBarChart(chartData: data)
 ```
 
 # View Modifiers
 
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .averageLine(chartData: data,
              strokeStyle: StrokeStyle(lineWidth: 3,dash: [5,10]))
 .yAxisPOI(chartData: data,
           markerName: "50",
           markerValue: 50,
           lineColour: Color.blue,
           strokeStyle: StrokeStyle(lineWidth: 3, dash: [5,10]))
 .xAxisGrid(chartData: data)
 .yAxisGrid(chartData: data)
 .xAxisLabels(chartData: data)
 .yAxisLabels(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct RangedBarChart<ChartData>: View where ChartData: RangedBarChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be RangedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                HStack(spacing: 0) {
                    switch chartData.barStyle.colourFrom {
                    case .barStyle:
                        RangedBarChartBarStyleSubView(chartData: chartData)
                            .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                    case .dataPoints:
                        RangedBarChartDataPointSubView(chartData: chartData)
                            .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                    }
                }
                // Needed for axes label frames
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
                .layoutNotifier(timer)
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}
