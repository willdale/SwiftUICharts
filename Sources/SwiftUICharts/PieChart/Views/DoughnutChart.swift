//
//  DoughnutChart.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

public struct DoughnutChart<ChartData>: View where ChartData: DoughnutChartData {
    
    @ObservedObject var chartData: ChartData
        
    @State var startAnimation : Bool = false
        
    public init(chartData : ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ZStack {
            ForEach(chartData.dataSets.dataPoints.indices, id: \.self) { data in
                DoughnutSegmentShape(id:         chartData.dataSets.dataPoints[data].id,
                                     startAngle: chartData.dataSets.dataPoints[data].startAngle,
                                     amount:     chartData.dataSets.dataPoints[data].amount)
                    .strokeBorder(chartData.dataSets.dataPoints[data].colour, lineWidth: chartData.chartStyle.strokeWidth)
                    .scaleEffect(startAnimation ? 1 : 0)
                    .opacity(startAnimation ? 1 : 0)
                    .animation(Animation.spring().delay(Double(data) * 0.06))
                    .if(chartData.infoView.touchOverlayInfo == [chartData.dataSets.dataPoints[data]]) {
                        $0
                            .scaleEffect(1.1)
                            .zIndex(1)
                            .shadow(color: Color.primary, radius: 10)
                    }
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
