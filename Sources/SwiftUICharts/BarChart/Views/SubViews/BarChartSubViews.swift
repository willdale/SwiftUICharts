//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

// MARK: - Standard
//
//
//
// MARK: Bar Style
internal struct BarChartBarStyleSubView<CD: BarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
            BarElement(chartData: chartData,
                       dataPoint: chartData.dataSets.dataPoints[index],
                       fill: chartData.barStyle.colour,
                       index: index)
        }
    }
}

// MARK: Data Points
internal struct BarChartDataPointSubView<CD: BarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { index in
            BarElement(chartData: chartData,
                       dataPoint: chartData.dataSets.dataPoints[index],
                       fill: chartData.dataSets.dataPoints[index].colour,
                       index: index)
        }
    }
}

// MARK: - Ranged
//
//
//
// MARK: Bar Style
internal struct RangedBarChartBarStyleSubView<CD:RangedBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            GeometryReader { geo in
                RangedBarCell(chartData: chartData,
                              dataPoint: dataPoint,
                              fill: chartData.barStyle.colour,
                              barSize: geo.frame(in: .local))
            }
        }
    }
}

// MARK: Data Points
internal struct RangedBarChartDataPointSubView<CD:RangedBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            GeometryReader { geo in
                RangedBarCell(chartData: chartData,
                              dataPoint: dataPoint,
                              fill: dataPoint.colour,
                              barSize: geo.frame(in: .local))
            }
        }
    }
}

// MARK: - Horizontal
//
//
//
// MARK: Bar Style
internal struct HorizontalBarChartBarStyleSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            HorizontalBarElement(chartData: chartData,
                                 dataPoint: dataPoint,
                                 fill: chartData.barStyle.colour)
        }
    }
}

// MARK: Data Points
internal struct HorizontalBarChartDataPointSubView<CD: HorizontalBarChartData>: View {
    
    @ObservedObject private var chartData: CD
    
    internal init(chartData: CD) {
        self.chartData = chartData
    }
    
    internal var body: some View {
        ForEach(chartData.dataSets.dataPoints) { dataPoint in
            HorizontalBarElement(chartData: chartData,
                                 dataPoint: dataPoint,
                                 fill: dataPoint.colour)
        }
    }
}
