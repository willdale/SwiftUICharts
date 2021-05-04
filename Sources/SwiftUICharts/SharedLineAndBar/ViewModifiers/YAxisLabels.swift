//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Automatically generated labels for the Y axis.
 */
internal struct YAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let specifier: String
    
    internal init(
        chartData: T,
        specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
        chartData.viewData.hasYAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                switch chartData.chartStyle.yAxisLabelPosition {
                case .leading:
                    HStack(spacing: 0) {
                        chartData.showYAxisTitle()
                        chartData.showYAxisLabels().padding(.trailing, 4)
                        content
                    }
                case .trailing:
                    HStack(spacing: 0) {
                        content
                        chartData.showYAxisLabels().padding(.leading, 4)
                        chartData.showYAxisTitle()
                    }
                }
            } else { content }
        }
    }
}

extension View {
    /**
     Automatically generated labels for the Y axis.
     
     Controls are in ChartData --> ChartStyle
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameters:
     - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels<T: CTLineBarChartDataProtocol>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier))
    }
}
