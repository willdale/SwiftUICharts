//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

@available(*, deprecated, message: "Use \".grid\" instead")
internal struct XAxisGrid<ChartData>: ViewModifier where ChartData: CTChartData {
    
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
            HStack {
                ForEach((0...style.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        VerticalGridView(chartData: chartData, style: style)
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
                VerticalGridView(chartData: chartData, style: style)
            }
            content
        }
    }
}

extension View {
    /// Adds vertical lines along the X axis.
    ///
    /// Verbose method
    @available(*, deprecated, message: "Use \".grid\" instead")
    public func xAxisGrid<ChartData>(
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
            XAxisGrid(
                chartData: chartData,
                style: GridStyle(numberOfLines: numberOfLines, lineColour: lineColour, lineWidth: lineWidth, dash: dash, dashPhase: dashPhase)
            )
        )
    }
    
    /// Adds vertical lines along the X axis.
    ///
    /// Convenience method
    @available(*, deprecated, message: "Use \".grid\" instead")
    public func xAxisGrid<ChartData>(
        chartData: ChartData,
        style: GridStyle = .standard
    ) -> some View
    where ChartData: CTChartData
    {
        self.modifier(
            XAxisGrid(
                chartData: chartData,
                style: style
            )
        )
    }
}
