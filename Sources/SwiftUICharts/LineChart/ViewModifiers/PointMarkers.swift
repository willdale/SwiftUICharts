//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 ViewModifier for for laying out point markers.
 */
internal struct PointMarkers<T>: ViewModifier where T: CTLineChartDataProtocol {
    
    @ObservedObject var chartData: T
    
    private let minValue : Double
    private let range    : Double
    
    internal init(chartData : T) {
        self.chartData  = chartData
        self.minValue   = chartData.minValue
        self.range      = chartData.range
    }
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
                content
                chartData.getPointMarker()
            } else { content }
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
    public func pointMarkers<T: CTLineChartDataProtocol>(chartData: T) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}
