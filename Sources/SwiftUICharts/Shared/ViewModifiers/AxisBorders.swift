//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct XAxisBorder: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
        
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        let labelsAndTop = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabels.labelPosition == .top
        let labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabels.labelPosition == .bottom
        
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

internal struct YAxisBorder: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        let labelsAndLeading = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabels.labelPosition == .leading
        let labelsAndTrailing = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabels.labelPosition == .trailing
        
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
    internal func xAxisBorder() -> some View {
        self.modifier(XAxisBorder())
    }

    internal func yAxisBorder() -> some View {
        self.modifier(YAxisBorder())
    }
}
