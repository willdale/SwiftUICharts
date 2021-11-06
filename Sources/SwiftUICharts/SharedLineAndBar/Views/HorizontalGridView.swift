//
//  HorizontalGridView.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

/**
 Sub view of the Y axis grid view modifier.
 */
internal struct HorizontalGridView<T>: View where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    @State private var startAnimation: Bool
    
    internal init(chartData: T) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.yAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.yAxisGridStyle.lineWidth,
                                       dash: chartData.chartStyle.yAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.yAxisGridStyle.dashPhase))
            .frame(height: chartData.chartStyle.yAxisGridStyle.lineWidth)
            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
}
