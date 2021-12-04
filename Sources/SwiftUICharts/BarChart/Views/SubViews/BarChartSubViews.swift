//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Standard
internal struct BarChartSubView<CD: BarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { i in
                BarElement(chartData: chartData,
                           dataPoint: chartData.dataSets.dataPoints[i],
                           fill: chartData.barStyle.colour,
                           index: i)
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { i in
                BarElement(chartData: chartData,
                           dataPoint: chartData.dataSets.dataPoints[i],
                           fill: chartData.dataSets.dataPoints[i].colour,
                           index: i)
            }
        }
    }
}

// MARK: - Horizontal
internal struct HorizontalBarChartSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints, id: \.id) { dataPoint in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: chartData.barStyle.colour)
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints, id: \.id) { dataPoint in
                HorizontalBarElement(chartData: chartData,
                                     dataPoint: dataPoint,
                                     fill: dataPoint.colour)
            }
        }
    }
}

// MARK: - Ranged
internal struct RangedBarSubView<CD:RangedBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    var body: some View {
        switch chartData.barStyle.colourFrom {
        case .barStyle:
            ForEach(chartData.dataSets.dataPoints, id: \.id) { dataPoint in
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: chartData.barStyle.colour,
                                  barSize: geo.frame(in: .local))
                }
            }
        case .dataPoints:
            ForEach(chartData.dataSets.dataPoints, id: \.id) { dataPoint in
                GeometryReader { geo in
                    RangedBarCell(chartData: chartData,
                                  dataPoint: dataPoint,
                                  fill: dataPoint.colour,
                                  barSize: geo.frame(in: .local))
                }
            }
        }
    }
}
