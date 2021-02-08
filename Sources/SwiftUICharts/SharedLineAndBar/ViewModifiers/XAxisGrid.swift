//
//  XAxisGrid.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisGrid<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData : T
        
    internal func body(content: Content) -> some View {
        ZStack {
//            if chartData.isGreaterThanTwo {
                HStack {
                    ForEach((0...chartData.chartStyle.xAxisGridStyle.numberOfLines), id: \.self) { index in
                        if index != 0 {
                            VerticalGridView(chartData: chartData)
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                    VerticalGridView(chartData: chartData)
                }
//            }
            content
        }
    }
}

extension View {
    /**
     Adds vertical lines along the X axis.
     
     The style is set in ChartData --> LineChartStyle --> xAxisGridStyle
     
     - Requires:
     Chart Data to conform to LineAndBarChartData.
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Bar Chart
     - Grouped Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with vertical lines under it.
     
     - Tag: XAxisGrid
    */
    public func xAxisGrid<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisGrid(chartData: chartData))
    }
}
