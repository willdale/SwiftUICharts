//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct XAxisBorder<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    private let labelsAndTop     : Bool
    private let labelsAndBottom  : Bool
    
    init(chartData: T) {
        self.chartData = chartData
        self.labelsAndTop    = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .top
        self.labelsAndBottom = chartData.viewData.hasXAxisLabels && chartData.chartStyle.xAxisLabelPosition == .bottom
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
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
            } else { content }
        }
    }
}

internal struct YAxisBorder<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    private let labelsAndLeading : Bool
    private let labelsAndTrailing: Bool
    
    init(chartData: T) {
        self.chartData = chartData
        self.labelsAndLeading  = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .leading
        self.labelsAndTrailing = chartData.viewData.hasYAxisLabels && chartData.chartStyle.yAxisLabelPosition == .trailing
    }
    
    internal func body(content: Content) -> some View {
        Group {
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
}

extension View {
    internal func xAxisBorder<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisBorder(chartData: chartData))
    }

    internal func yAxisBorder<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(YAxisBorder(chartData: chartData))
    }
}
