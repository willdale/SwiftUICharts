//
//  HorizontalBarChart.swift
//
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

public struct HorizontalBarChart<ChartData>: View where ChartData: HorizontalBarChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be BarChartData model.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        GeometryReader { geo in
            if chartData.isGreaterThanTwo() {
                VStack(spacing: 0) {
                    switch chartData.barStyle.colourFrom {
                    case .barStyle:
                        HorizontalBarChartBarStyleSubView(chartData: chartData)
                            .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                    case .dataPoints:
                        HorizontalBarChartDataPointSubView(chartData: chartData)
                            .accessibilityLabel(LocalizedStringKey(chartData.metadata.title))
                    }
                }
                // Needed for axes label frames
                .onChange(of: geo.frame(in: .local)) { value in
                    self.chartData.viewData.chartSize = value
                }
                .layoutNotifier(timer)
            } else { CustomNoDataView(chartData: chartData) }
        }
        .if(chartData.minValue.isLess(than: 0)) {
            $0.scaleEffect(x: CGFloat(chartData.maxValue/(chartData.maxValue - chartData.minValue)), anchor: .trailing)
        }
    }
}
