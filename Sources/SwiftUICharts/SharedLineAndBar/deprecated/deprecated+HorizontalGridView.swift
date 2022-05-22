//
//  deprecated+HorizontalGridView.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

@available(*, deprecated, message: "Use \".grid\" instead")
internal struct HorizontalGridView<ChartData>: View where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    private var style: GridStyle
    
    @State private var startAnimation: Bool = false
    
    internal init(
        chartData: ChartData,
        style: GridStyle
    ) {
        self.chartData = chartData
        self.style = style
    }
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(style.lineColour,
                    style: StrokeStyle(lineWidth: style.lineWidth,
                                       dash: style.dash,
                                       dashPhase: style.dashPhase))
            .frame(height: style.lineWidth)
            .animateOnAppear(disabled: false, using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
    }
}
