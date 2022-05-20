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
    
    internal init(chartData: T) {
        self.chartData = chartData
    }
    
    @State private var startAnimation: Bool = false
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: animationValue)
            .stroke(chartData.chartStyle.yAxisGridStyle.lineColour,
                    style: StrokeStyle(lineWidth: chartData.chartStyle.yAxisGridStyle.lineWidth,
                                       dash: chartData.chartStyle.yAxisGridStyle.dash,
                                       dashPhase: chartData.chartStyle.yAxisGridStyle.dashPhase))
            .frame(height: chartData.chartStyle.yAxisGridStyle.lineWidth)
            .animateOnAppear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = true
            }
            .animateOnDisappear(disabled: chartData.disableAnimation, using: chartData.chartStyle.globalAnimation) {
                self.startAnimation = false
            }
    }
    
    var animationValue: CGFloat {
        if chartData.disableAnimation {
            return 1
        } else {
            return startAnimation ? 1 : 0
        }
    }
}
