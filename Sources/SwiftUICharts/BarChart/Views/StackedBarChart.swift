//
//  StackedBarChart.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI


public struct StackedBarChart<ChartData>: View where ChartData: StackedBarChartData {
    
    @ObservedObject var chartData: ChartData
            
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
                
        if chartData.isGreaterThanTwo() {
            
            HStack(alignment: .bottom, spacing: 0) {
                ForEach(chartData.dataSets.dataSets) { dataSet in
                    
                    MultiPartBarView(dataSet: dataSet)
                        .scaleEffect(y: CGFloat(DataFunctions.dataSetMaxValue(from: dataSet) / chartData.getMaxValue()),
                                     anchor: .bottom)
                }
            }

        } else { CustomNoDataView(chartData: chartData) }
    }
}

struct MultiPartBarView: View {
    
    let dataSet : BarDataSet
    
    init(dataSet: BarDataSet) {
        self.dataSet = dataSet
    }
    
    var body: some View {
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                ForEach(dataSet.dataPoints.reversed()) { datapoint in
                    
                    Rectangle()
                        .fill(datapoint.colour ?? .pink)
                        .frame(height: getHeight(height: geo.size.height,
                                                 dataSet: dataSet,
                                                 dataPoint: datapoint))
                }
            }
        }
    }
    
    func getHeight(height: CGFloat, dataSet: BarDataSet, dataPoint: BarChartDataPoint) -> CGFloat {
        let value = dataPoint.value
        let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
        return height * CGFloat(value / sum)
    }
}
