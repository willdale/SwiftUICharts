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
internal struct XAxisLabels<T>: ViewModifier where T: LineAndBarChartData {
    
    @ObservedObject var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
        self.chartData.viewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.xAxisLabelPosition {
            case .top:
//                if chartData.isGreaterThanTwo() {
                    VStack {
                        chartData.getXAxisLabels()
                        content
                    }
//                } else { content }
            case .bottom:
//                if chartData.isGreaterThanTwo() {
                    VStack {
                        content
                        chartData.getXAxisLabels()
                    }
//                } else { content }
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
     - Stacked Bar Chart
     
     # Unavailable for:
     - Pie Chart
     - Doughnut Chart
     - Multi Layer Pie Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with labels marking the x axis.
     */
    public func xAxisLabels<T: LineAndBarChartData>(chartData: T) -> some View {
        self.modifier(XAxisLabels(chartData: chartData))
    }
}
