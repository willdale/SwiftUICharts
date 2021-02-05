//
//  GroupedBarChart.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

public struct GroupedBarChart<ChartData>: View where ChartData: MultiBarChartData {
    
    @ObservedObject var chartData: ChartData
        
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        HStack(spacing: 100) {
            ForEach(chartData.dataSets.dataSets) { dataSet in
                VStack {
                    HStack(spacing: 0) {
                        ForEach(dataSet.dataPoints) { dataPoint in
                            
                            switch dataSet.style.colourFrom {
                            case .barStyle:
                                
                                BarChartDataSetSubView(colourType: dataSet.style.colourType,
                                                       dataPoint: dataPoint,
                                                       style: dataSet.style,
                                                       chartStyle: chartData.chartStyle,
                                                       maxValue: chartData.getMaxValue())
                                
                            case .dataPoints:
                                
                                BarChartDataPointSubView(colourType: dataPoint.colourType,
                                                         dataPoint: dataPoint,
                                                         style: dataSet.style,
                                                         chartStyle: chartData.chartStyle,
                                                         maxValue: chartData.getMaxValue())
                                
                            }
                        }
                    }
                }
            }
        }
    }
}