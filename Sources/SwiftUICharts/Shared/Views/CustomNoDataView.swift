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
public struct CustomNoDataView<T>: View where T: ChartData {
    
    let chartData : T
    
    init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        chartData.noDataText
    }
}
