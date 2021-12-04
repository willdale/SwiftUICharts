//
//  BarChartSubViews.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI



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
