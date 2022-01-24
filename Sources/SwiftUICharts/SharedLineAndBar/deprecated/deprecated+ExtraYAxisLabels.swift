//
//  deprecated+ExtraYAxisLabels.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

@available(*, deprecated, message: "")
internal struct ExtraYAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & YAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let specifier: String
    private let colourIndicator: AxisColour
    
    internal init(
        chartData: ChartData,
        specifier: String,
        colourIndicator: AxisColour
    ) {
        self.chartData = chartData
        self.specifier = specifier
        self.colourIndicator = colourIndicator
        chartData.yAxisViewData.hasYAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        content
    }
}

extension View {
    /**
     Adds a second set of Y axis labels.
     
     - Parameters:
        - chartData: Data that conforms to CTLineBarChartDataProtocol.
        - specifier: Decimal precision for labels.
        - colourIndicator: Second Y Axis style.
     - Returns: A View with second set of Y axis labels.
     */
    @available(*, deprecated, message: "")
    public func extraYAxisLabels<ChartData>(
        chartData: ChartData,
        specifier: String = "%.0f",
        colourIndicator: AxisColour = .none
    ) -> some View
    where ChartData: CTChartData & YAxisViewDataProtocol
    {
        self.modifier(ExtraYAxisLabels(chartData: chartData, specifier: specifier, colourIndicator: colourIndicator))
    }
}

