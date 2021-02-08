//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

internal struct XAxisLabels<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
        self.chartData.viewData.hasXAxisLabels = true
    }
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        switch chartData.chartStyle.xAxisLabelPosition {
        case .top:
            VStack {
                chartData.getXAxisLabels()
                content
            }
        case .bottom:
            VStack {
                content
                chartData.getXAxisLabels()
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
     - Returns: A  new view containing the chart with labels marking the x axis.
     
     - Tag: XAxisLabels
     */
    public func xAxisLabels<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
