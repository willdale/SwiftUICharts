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
    private let colourIndicator: AxisColour
    private let formatter: NumberFormatter?
    
    internal init(
        chartData: T,
        specifier: String,
        formatter: NumberFormatter?,
        colourIndicator: AxisColour
    ) {
        self.chartData = chartData
        self.specifier = specifier
        self.colourIndicator = colourIndicator
        self.formatter = formatter
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                switch chartData.chartStyle.yAxisLabelPosition {
                case .leading:
                    HStack(spacing: 0) {
                        chartData.getYAxisTitle(colour: colourIndicator)
                        chartData.getYAxisLabels().padding(.trailing, 4)
                        content
                    }
                case .trailing:
                    HStack(spacing: 0) {
                        content
                        chartData.getYAxisLabels().padding(.leading, 4)
                        chartData.getYAxisTitle(colour: colourIndicator)
                    }
                }
            } else { content }
        }
        .onAppear {
            chartData.viewData.hasYAxisLabels = true
            chartData.viewData.yAxisSpecifier = specifier
            chartData.viewData.yAxisNumberFormatter = formatter
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
        - chartData: Data that conforms to CTLineBarChartDataProtocol
        - specifier: Decimal precision specifier
     - Returns: HStack of labels
     */
    public func yAxisLabels<T: CTLineBarChartDataProtocol>(
        chartData: T,
        specifier: String = "%.0f",
        formatter: NumberFormatter? = nil,
        colourIndicator: AxisColour = .none
    ) -> some View {
        self.modifier(YAxisLabels(chartData: chartData, specifier: specifier, formatter: formatter, colourIndicator: colourIndicator))
    }
}
