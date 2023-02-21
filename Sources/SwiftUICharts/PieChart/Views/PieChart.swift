//
//  PieChart.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 View for creating a pie chart.
 
 Uses `PieChartData` data model.
 
 # Declaration
 ```
 PieChart(chartData: data)
 ```
 
 # View Modifiers
 The order of the view modifiers is some what important
 as the modifiers are various types for stacks that wrap
 around the previous views.
 ```
 .touchOverlay(chartData: data)
 .infoBox(chartData: data)
 .floatingInfoBox(chartData: data)
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct PieChart<ChartData>: View where ChartData: PieChartData {
    
    @ObservedObject private var chartData: ChartData
    @State private var timer: Timer?
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be PieChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation: Bool = false
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                    PieSegmentShape(id: chartData.dataSets.dataPoints[data].id,
                                    startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                    amount: chartData.dataSets.dataPoints[data].amount)
                        .fill(chartData.dataSets.dataPoints[data].colour)
                        .overlay(dataPoint: chartData.dataSets.dataPoints[data], chartData: chartData, rect: geo.frame(in: .local))
                        .scaleEffect(animationValue)
                        .opacity(Double(animationValue))
                        .animation(Animation.spring().delay(Double(data) * 0.06))
                        .if(chartData.infoView.touchOverlayInfo == [chartData.dataSets.dataPoints[data]]) {
                            $0
                                .scaleEffect(1.1)
                                .zIndex(1)
                                .shadow(color: Color.primary, radius: 10)
                        }
                        .accessibilityLabel(chartData.metadata.title)
                        .accessibilityValue(chartData.dataSets.dataPoints[data].getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier,
                                                                                                          formatter: chartData.infoView.touchFormatter))
                }
            }
        }
        .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
        .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = false
        }
        .layoutNotifier(timer)
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0.001
        }
    }
}
