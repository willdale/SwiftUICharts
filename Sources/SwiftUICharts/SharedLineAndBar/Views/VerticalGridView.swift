//
//  VerticalGridView.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

internal struct VerticalGridView<T>: View where T: LineAndBarChartData {
    
    var chartData : T
    
    @State var startAnimation : Bool = false
    
    var body: some View {
        VerticalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.xAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.xAxisGridStyle.lineWidth,
                                       dash     : chartData.chartStyle.xAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.xAxisGridStyle.dashPhase))
            .frame(width: chartData.chartStyle.xAxisGridStyle.lineWidth)
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}