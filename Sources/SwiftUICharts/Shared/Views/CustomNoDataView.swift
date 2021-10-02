//
//  CustomNoDataView.swift
//  
//
//  Created by Will Dale on 17/01/2021.
//

import SwiftUI

/**
 View to display text if there is not enough data to draw the chart.
 */
public struct CustomNoDataView<ChartData>: View where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    
    init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        chartData.noDataText
    }
}
