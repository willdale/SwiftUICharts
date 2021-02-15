//
//  BarChart.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject var chartData: ChartData
    
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        if chartData.isGreaterThanTwo() {
            HStack(spacing: 0) {
                ForEach(chartData.dataSets.dataPoints) { dataPoint in
                    
                    switch chartData.barStyle.colourFrom {
                    case .barStyle:
                        
                        BarChartDataSetSubView(chartData    : chartData,
                                               dataPoint    : dataPoint)
                        
                    case .dataPoints:
                        
                        BarChartDataPointSubView(chartData   : chartData,
                                                 dataPoint   : dataPoint)
                        
                    }
                }
            }
        } else { CustomNoDataView(chartData: chartData) }
    }
}
