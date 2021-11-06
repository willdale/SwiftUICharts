//
//  VerticalGridView.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

/**
 Sub view of the X axis grid view modifier.
 */
internal struct VerticalGridView<T>: View where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    @State private var startAnimation: Bool
    
    internal init(chartData: T) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    var body: some View {
        VerticalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(chartData.chartStyle.xAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.xAxisGridStyle.lineWidth,
                                       dash: chartData.chartStyle.xAxisGridStyle.dash,
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
