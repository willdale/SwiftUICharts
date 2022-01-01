//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

/**
 Labels for the X axis.
 */
internal struct XAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & ChartAxes & ViewDataProtocol,
                                                           ChartData.CTStyle: CTLineBarChartStyle {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
        self.chartData.xAxisViewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.xAxisLabelPosition {
            case .bottom:
                VStack {
                    content
                    chartData.getXAxisLabels().padding(.top, 2)
                    chartData.getXAxisTitle()
                }
            case .top:
                VStack {
                    chartData.getXAxisTitle()
                    chartData.getXAxisLabels().padding(.bottom, 2)
                    content
                }
            }
        }
    }
}

extension View {
    /**
     Labels for the X axis.
     
     The labels can either come from ChartData -->  xAxisLabels
     or ChartData --> DataSets --> DataPoints
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
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
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with labels marking the x axis.
     */
    public func xAxisLabels<ChartData>(chartData: ChartData) -> some View
    where ChartData: CTChartData & ChartAxes & ViewDataProtocol,
          ChartData.CTStyle: CTLineBarChartStyle
    {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
