//
//  RangedBarChart.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 View for creating a grouped bar chart.
  
 Uses `GroupedBarChartData` data model.
 
 # Declaration
 ```
 GroupedBarChart(chartData: data, groupSpacing: 25)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .averageLine(chartData: data)
 .yAxisPOI(chartData: data)
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
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be RangedBarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(spacing: 0) {
                
                switch chartData.barStyle.colourFrom {
                case .barStyle:
                    
                    RangedBarChartBarStyleSubView(chartData: chartData)
                        .accessibilityLabel( Text("\(chartData.metadata.title)"))
                case .dataPoints:
                    
                    RangedBarChartDataPointSubView(chartData: chartData)
                        .accessibilityLabel( Text("\(chartData.metadata.title)"))
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
