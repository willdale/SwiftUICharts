//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/**
 Dividing line drawn between the X axis labels and the chart.
 */
internal struct XAxisBorder<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let labelsAndTop: Bool
    private let labelsAndBottom: Bool
    
    init(chartData: T) {
        self.chartData = chartData
        self.labelsAndTop = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        self.labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                if labelsAndBottom {
                    VStack {
                        ZStack(alignment: .bottom) {
                            content
                            Divider().if(chartData.chartStyle.xAxisBorderColour != nil) { $0.background(chartData.chartStyle.xAxisBorderColour) }
                        }
                    }
                } else if labelsAndTop {
                    VStack {
                        ZStack(alignment: .top) {
                            content
                            Divider().if(chartData.chartStyle.xAxisBorderColour != nil) { $0.background(chartData.chartStyle.xAxisBorderColour) }
                        }
                    }
                } else {
                    content
                }
            } else { content }
        }
    }
}

/**
 Dividing line drawn between the Y axis labels and the chart.
 */
internal struct YAxisBorder<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let labelsAndLeading: Bool
    private let labelsAndTrailing: Bool
    
    internal init(chartData: T) {
        self.chartData = chartData
        self.labelsAndLeading = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .leading
        self.labelsAndTrailing = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .trailing
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if labelsAndLeading {
                HStack {
                    ZStack(alignment: .leading) {
                        content
                        Divider().if(chartData.chartStyle.yAxisBorderColour != nil) { $0.background(chartData.chartStyle.yAxisBorderColour) }
                    }
                }
            } else if labelsAndTrailing {
                HStack {
                    ZStack(alignment: .trailing) {
                        content
                        Divider().if(chartData.chartStyle.yAxisBorderColour != nil) { $0.background(chartData.chartStyle.yAxisBorderColour) }
                    }
                }
            } else {
                content
            }
        }
    }
}

extension View {
    internal func xAxisBorder<T: CTLineBarChartDataProtocol>(chartData: T) -> some View {
        self.modifier(XAxisBorder(chartData: chartData))
    }
    
    internal func yAxisBorder<T: CTLineBarChartDataProtocol>(chartData: T) -> some View {
        self.modifier(YAxisBorder(chartData: chartData))
    }
}
