//
//  BarChartView.swift
//  
//
//  Created by Will Dale on 11/01/2021.
//

import SwiftUI

public struct BarChart<ChartData>: View where ChartData: BarChartData {
    
    @ObservedObject var chartData: ChartData
    
    let maxValue : Double
    
    public init(chartData: ChartData) {
        self.chartData = chartData
        self.maxValue = DataFunctions.maxValue(dataPoints: chartData.dataSets.dataPoints)
//        chartData.viewData.chartType = .bar

        setupLegends()
    }
    
    public var body: some View {

        HStack(spacing: 0) {
            ForEach(chartData.dataSets.dataPoints) { dataPoint in
                
                switch chartData.dataSets.style.colourFrom {
                case .barStyle:
                    
                    BarChartDataSetSubView(colourType: chartData.dataSets.style.colourType,
                                           dataPoint: dataPoint,
                                           style: chartData.dataSets.style,
                                           chartStyle: chartData.chartStyle,
                                           maxValue: maxValue)

                case .dataPoints:
                    
                    BarChartDataPointSubView(colourType  : dataPoint.colourType,
                                             dataPoint   : dataPoint,
                                             style       : chartData.dataSets.style,
                                             chartStyle  : chartData.chartStyle,
                                             maxValue    : maxValue)

                }
            }
        }
    }
    internal mutating func setupLegends() {
        AddLegends.setupBar(chartData: &chartData, dataSet: chartData.dataSets)
    }
}
