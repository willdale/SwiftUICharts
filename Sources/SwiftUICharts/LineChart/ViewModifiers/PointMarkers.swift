//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers<T>: ViewModifier where T: LineChartDataProtocol {
        
    @ObservedObject var chartData: T
        
    private let minValue : Double
    private let range    : Double
        
    internal init(chartData : T) {
        self.chartData  = chartData
        self.minValue   = chartData.getMinValue()
        self.range      = chartData.getRange()
    }
    internal func body(content: Content) -> some View {
        ZStack {
            if chartData.isGreaterThanTwo() {
            content
            
                if chartData.chartType.dataSetType == .single {
                    
                    let data = chartData as! LineChartData
                    PointsSubView(dataSets: data.dataSets,
                                  minValue: minValue,
                                  range: range,
                                  animation: chartData.chartStyle.globalAnimation,
                                  isFilled: chartData.isFilled)
                    
                } else if chartData.chartType.dataSetType == .multi {
                    
                    let data = chartData as! MultiLineChartData
                    ForEach(data.dataSets.dataSets, id: \.self) { dataSet in
                        PointsSubView(dataSets: dataSet,
                                      minValue: minValue,
                                      range: range,
                                      animation: chartData.chartStyle.globalAnimation,
                                      isFilled: chartData.isFilled)
                    }
                }
            } else { content }
        }
    }
}

extension View {
    /**
     Lays out markers over each of the data point.
     
     The style of the markers is set in the PointStyle data model as parameter in ChartData
     
     - Requires:
     Chart Data to conform to LineChartDataProtocol.
     - LineChartData
     - MultiLineChartData
     
     # Available for:
     - Line Chart
     - Multi Line Chart
     
     # Unavailable for:
     - Bar Chart
     - Grouped Bar Chart
     - Pie Chart
     - Doughnut Chart
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with point markers.
     
     - Tag: PointMarkers
     */
    public func pointMarkers<T: LineChartDataProtocol>(chartData: T) -> some View {
        self.modifier(PointMarkers(chartData: chartData))
    }
}
