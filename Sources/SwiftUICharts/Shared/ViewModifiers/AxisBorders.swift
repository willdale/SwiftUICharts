//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct XAxisBorder<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
        
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        let labelsAndTop = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
        
        if labelsAndBottom {
            VStack {
                ZStack(alignment: .bottom) {
                    content
                    Divider()
                }
            }
        } else if labelsAndTop {
            VStack {
                ZStack(alignment: .top) {
                    content
                    Divider()
                }
            }
        } else {
            content
        }
    }
}

internal struct YAxisBorder<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        let labelsAndLeading = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .leading
        let labelsAndTrailing = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .trailing
        
        if labelsAndLeading {
            HStack {
                ZStack(alignment: .leading) {
                    content
                    Divider()
                }
            }
        } else if labelsAndTrailing {
            HStack {
                ZStack(alignment: .trailing) {
                    content
                    Divider()
                }
            }
        } else {
            content
        }
    }
}

extension View {
    internal func xAxisBorder<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisBorder(chartData: chartData))
    }

    internal func yAxisBorder<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(YAxisBorder(chartData: chartData))
    }
}
