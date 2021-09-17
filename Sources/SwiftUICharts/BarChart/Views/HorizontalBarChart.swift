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
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                VStack(spacing: 0) {
                    switch chartData.barStyle.colourFrom {
                    case .barStyle:
                        HorizontalBarChartBarStyleSubView(chartData: chartData)
                            .ctAccessibilityLabel(chartData.metadata.title)
                    case .dataPoints:
                        HorizontalBarChartDataPointSubView(chartData: chartData)
                            .ctAccessibilityLabel(chartData.metadata.title)
                    }
                }
                .onAppear {
                    self.chartData.viewData.chartSize = geo.frame(in: .local)
                }
            } else { CustomNoDataView(chartData: chartData) }
        }
    }
}
