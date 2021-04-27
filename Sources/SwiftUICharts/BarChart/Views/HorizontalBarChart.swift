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
                ForEach(chartData.dataSets.dataPoints) { dataPoint in
                    Rectangle()
                        .fill(dataPoint.colour.colour ?? .blue)
                        .scaleEffect(x: CGFloat(dataPoint.value / chartData.maxValue), anchor: .leading)
                        .scaleEffect(y: chartData.barStyle.barWidth, anchor: .center)
                        .background(Color(.gray).opacity(0.000000001))
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
