//
//  YAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Adds horizontal lines along the X axis.
 */
internal struct YAxisGrid<ChartData>: ViewModifier where ChartData: CTChartData,
                                                         ChartData.CTStyle: CTLineBarChartStyle {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            VStack {
                ForEach((0...chartData.chartStyle.yAxisGridStyle.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        HorizontalGridView(chartData: chartData)
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                    }
                }
                HorizontalGridView(chartData: chartData)
            }
            content
        }
    }
}

extension View {
    /**
     Adds horizontal lines along the X axis.
     
     The style is set in ChartData --> LineChartStyle --> yAxisGridStyle
     
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
     - Returns: A  new view containing the chart with horizontal lines under it.
     */
    public func yAxisGrid<ChartData>(chartData: ChartData) -> some View
    where ChartData: CTChartData,
          ChartData.CTStyle: CTLineBarChartStyle
    {
        self.modifier(YAxisGrid<ChartData>(chartData: chartData))
    }
}
