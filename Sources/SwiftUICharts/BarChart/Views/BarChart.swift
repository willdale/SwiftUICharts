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
public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(spacing: 0) {
                
                    switch chartData.barStyle.colourFrom {
                    case .barStyle:
                        
                        BarChartBarStyleSubView(chartData: chartData)
                            .accessibilityLabel(Text("\(chartData.metadata.title)"))
                        
                    case .dataPoints:
                        
                        BarChartDataPointSubView(chartData: chartData)
                            .accessibilityLabel(Text("\(chartData.metadata.title)"))
                    }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
