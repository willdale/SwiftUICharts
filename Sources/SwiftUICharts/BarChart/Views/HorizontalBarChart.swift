//
//  HorizontalBarChart.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

public struct HorizontalBarChart<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            VStack(spacing: 0) {
                switch chartData.barStyle.colourFrom {
                case .barStyle:
                    HorizontalBarChartBarStyleSubView(chartData: chartData)
                        .accessibilityLabel(Text("\(chartData.metadata.title)"))
                case .dataPoints:
                    HorizontalBarChartDataPointSubView(chartData: chartData)
                        .accessibilityLabel(Text("\(chartData.metadata.title)"))
                }
                
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
