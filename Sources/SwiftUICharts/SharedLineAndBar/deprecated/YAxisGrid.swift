//
//  YAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

@available(*, deprecated, message: "Use \".grid\" instead")
internal struct YAxisGrid<ChartData>: ViewModifier where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    private var style: GridStyle
    
    internal init(
        chartData: ChartData,
        style: GridStyle
    ) {
        self.chartData = chartData
        self.style = style
    }

    internal func body(content: Content) -> some View {
        ZStack {
            VStack {
                ForEach((0...style.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        HorizontalGridView(chartData: chartData, style: style)
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                    }
                }
                HorizontalGridView(chartData: chartData, style: style)
            }
            content
        }
    }
}

extension View {
    /// Adds horizontal lines along the Y axis.
    ///
    /// Verbose method
    @available(*, deprecated, message: "Use \".grid\" instead")
    public func yAxisGrid<ChartData>(
        chartData: ChartData,
        numberOfLines: Int,
        lineColour: Color,
        lineWidth: CGFloat,
        dash: [CGFloat],
        dashPhase: CGFloat
    ) -> some View
    where ChartData: CTChartData
    {
        self.modifier(
            YAxisGrid(
                chartData: chartData,
                style: GridStyle(numberOfLines: numberOfLines, lineColour: lineColour, lineWidth: lineWidth, dash: dash, dashPhase: dashPhase)
            )
        )
    }
    
    /// Adds horizontal lines along the Y axis.
    ///
    /// Convenience method
    @available(*, deprecated, message: "Use \".grid\" instead")
    public func yAxisGrid<ChartData>(
        chartData: ChartData,
        style: GridStyle = .standard
    ) -> some View
    where ChartData: CTChartData
    {
        self.modifier(
            YAxisGrid(
                chartData: chartData,
                style: style
            )
        )
    }
}
