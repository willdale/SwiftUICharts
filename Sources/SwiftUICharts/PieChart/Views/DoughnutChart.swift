//
//  DoughnutChart.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 View for creating a doughnut chart.
 
 Uses `DoughnutChartData` data model.
 
 # Declaration
 ```
 DoughnutChart(chartData: data)
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
public struct DoughnutChart<ChartData>: View where ChartData: DoughnutChartData {
    
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation: Bool
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be DoughnutChartData.
    public init(chartData: ChartData) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    public var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                    DoughnutSegmentShape(id: chartData.dataSets.dataPoints[data].id,
                                         startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                         amount: chartData.dataSets.dataPoints[data].amount)
                        .stroke(chartData.dataSets.dataPoints[data].colour,
                                lineWidth: chartData.strokeWidth)
                        .overlay(dataPoint: chartData.dataSets.dataPoints[data],
                                 chartData: chartData,
                                 rect: geo.frame(in: .local))
                        .scaleEffect(startAnimation ? 1 : 0)
                        .opacity(startAnimation ? 1 : 0)
                        .animation(Animation.spring().delay(Double(data) * 0.06))
                        .if(chartData.touchPointData == [chartData.dataSets.dataPoints[data]]) {
                            $0
                                .scaleEffect(1.1)
                                .zIndex(1)
                                .shadow(color: Color.primary, radius: 10)
                        }
                        .accessibilityLabel(chartData.accessibilityTitle)
//                        .accessibilityValue(chartData.dataSets.dataPoints[data].getCellAccessibilityValue(specifier: chartData.infoView.touchSpecifier))
                }
            }
        }
        .animateOnAppear(using: .linear) {
            self.startAnimation = true
        }
        .onDisappear {
            self.startAnimation = false
        }
    }
}
