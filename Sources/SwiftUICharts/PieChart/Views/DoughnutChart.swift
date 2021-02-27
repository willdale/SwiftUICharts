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
 .headerBox(chartData: data)
 .legends(chartData: data)
 ```
 */
public struct DoughnutChart<ChartData>: View where ChartData: DoughnutChartData {
    
    @ObservedObject var chartData: ChartData
    
    /// Initialises a bar chart view.
    /// - Parameter chartData: Must be DoughnutChartData.
    public init(chartData : ChartData) {
        self.chartData = chartData
    }
    
    @State private var startAnimation : Bool = false
    
    public var body: some View {
        ZStack {
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                DoughnutSegmentShape(id:         chartData.dataSets.dataPoints[data].id,
                                     startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                     amount:     chartData.dataSets.dataPoints[data].amount)
                    .stroke(chartData.dataSets.dataPoints[data].colour, lineWidth: chartData.chartStyle.strokeWidth)
                    .scaleEffect(startAnimation ? 1 : 0)
                    .opacity(startAnimation ? 1 : 0)
                    .animation(Animation.spring().delay(Double(data) * 0.06))
                    .if(chartData.infoView.touchOverlayInfo == [chartData.dataSets.dataPoints[data]]) {
                        $0
                            .scaleEffect(1.1)
                            .zIndex(1)
                            .shadow(color: Color.primary, radius: 10)
                    }
                    .accessibilityLabel(Text("\(chartData.metadata.title)"))
                    .accessibilityValue(Text(String(format: chartData.infoView.touchSpecifier, chartData.dataSets.dataPoints[data].value) + "\(chartData.dataSets.dataPoints[data].pointDescription ?? "")"))
            }
        }
        .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = true
        }
        .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
            self.startAnimation = false
        }
    }
}
