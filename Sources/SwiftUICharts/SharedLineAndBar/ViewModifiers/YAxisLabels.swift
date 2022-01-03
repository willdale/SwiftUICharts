//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

public struct YAxisLabelStyle {
    var position: YAxisLabelPosistion
    var font: Font
    var fontColour: Color
    var number: Int
    var type: YAxisLabelType
    var colourIndicator: AxisColour
    var formatter: NumberFormatter
}

extension YAxisLabelStyle {
    public static let standard = YAxisLabelStyle(position: .leading,
                                                 font: .caption,
                                                 fontColour: .primary,
                                                 number: 10,
                                                 type: .numeric,
                                                 colourIndicator: .none,
                                                 formatter: .default)
}


internal struct YAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & AxisY & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.style = style
        self.chartData.yAxisViewData.hasYAxisLabels = true
        self.chartData.yAxisViewData.yAxisNumberFormatter = style.formatter
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch style.position {
            case .leading:
                HStack(spacing: 0) {
                    chartData.getYAxisLabels()
                        .padding(.trailing, 4)
                    content
                }
            case .trailing:
                HStack(spacing: 0) {
                    content
                    chartData.getYAxisLabels()
                        .padding(.leading, 4)
                }
            }
        }
    }
}

extension View {
    /// Labels for the X axis.
    ///
    /// Verbose method
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        position: YAxisLabelPosistion,
        font: Font,
        fontColour: Color,
        number: Int,
        type: YAxisLabelType,
        colourIndicator: AxisColour,
        formatter: NumberFormatter
    ) -> some View
    where ChartData: CTChartData & AxisY & ViewDataProtocol
    {
        self.modifier(
            YAxisLabels(
                chartData: chartData,
                style: YAxisLabelStyle(position: position, font: font, fontColour: fontColour, number: number, type: type, colourIndicator: colourIndicator, formatter: formatter)
            )
        )
    }
    
    /// Labels for the X axis.
    ///
    /// Convenience method
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        style: YAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & AxisY & ViewDataProtocol
    {
        self.modifier(YAxisLabels(chartData: chartData,
                                  style: style)
        )
    }
}
