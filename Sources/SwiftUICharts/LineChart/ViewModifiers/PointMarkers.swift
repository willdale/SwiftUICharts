//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers<ChartData>: ViewModifier
where ChartData: CTChartData & CTLineChartDataProtocol & GetDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    internal func body(content: Content) -> some View {
        ZStack {
            content
            chartData.getPointMarker()
        }
    }
}

extension View {
    /**
     Lays out markers over each of the data point.
     
     The style of the markers is set in the PointStyle data model as parameter in the Chart Data.
     
     - Requires:
     Chart Data to conform to CTLineChartDataProtocol.
     - LineChartData
     - MultiLineChartData
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     - Filled Line Chart
     - Ranged Line Chart
     
     # Unavailable for:
     - Bar Chart
     - Grouped Bar Chart
     - Stacked Bar Chart
     - Ranged Bar Chart
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with point markers.
     
     */
    public func pointMarkers<ChartData: CTChartData & CTLineChartDataProtocol & GetDataProtocol>(chartData: ChartData) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}
