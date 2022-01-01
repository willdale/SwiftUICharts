//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

/**
 Adds vertical lines along the X axis.
 */
internal struct XAxisGrid<ChartData>: ViewModifier where ChartData: CTChartData,
                                                         ChartData.CTStyle: CTLineBarChartStyle {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            HStack {
                ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        VerticalGridView(chartData: chartData)
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
                VerticalGridView(chartData: chartData)
            }
            content
        }
    }
}

extension View {
    /**
     Adds vertical lines along the X axis.
     
     The style is set in ChartData --> ChartStyle --> xAxisGridStyle
     
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
     - Returns: A  new view containing the chart with vertical lines under it.
     */
    public func xAxisGrid<ChartData>(chartData: ChartData) -> some View
    where ChartData: CTChartData,
          ChartData.CTStyle: CTLineBarChartStyle
    {
        self.modifier(XAxisGrid(chartData: chartData))
    }
}
