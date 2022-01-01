//
//  ExtraYAxisLabels.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

internal struct ExtraYAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol & YAxisViewDataProtocol {
    
    @ObservedObject private var chartData: T
    private let specifier: String
    private let colourIndicator: AxisColour
    
    internal init(
        chartData: T,
        specifier: String,
        colourIndicator: AxisColour
    ) {
        self.chartData = chartData
        self.specifier = specifier
        self.colourIndicator = colourIndicator
        chartData.yAxisViewData.hasYAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.yAxisLabelPosition {
            case .leading:
                HStack(spacing: 0) {
                    content
                    chartData.getExtraYAxisLabels().padding(.leading, 4)
                    chartData.getExtraYAxisTitle(colour: colourIndicator)
                }
            case .trailing:
                HStack(spacing: 0) {
                    chartData.getExtraYAxisTitle(colour: colourIndicator)
                    chartData.getExtraYAxisLabels().padding(.trailing, 4)
                    content
                }
            }
        }
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
    public func extraYAxisLabels<T: CTLineBarChartDataProtocol & YAxisViewDataProtocol>(
        chartData: T,
        specifier: String = "%.0f",
        colourIndicator: AxisColour = .none
    ) -> some View {
        self.modifier(ExtraYAxisLabels(chartData: chartData, specifier: specifier, colourIndicator: colourIndicator))
    }
}

