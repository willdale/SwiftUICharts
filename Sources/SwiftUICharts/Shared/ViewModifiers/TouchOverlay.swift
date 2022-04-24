//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

// MARK: - API
extension View {
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touch<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        minDistance: CGFloat = 0
    ) -> some View {
        #if !os(tvOS)
        self.modifier(TouchOverlay(chartData: chartData,
                                   minDistance: minDistance))
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}

#if !os(tvOS)
/**
 Finds the nearest data point and displays the relevent information.
 */
internal struct TouchOverlay<ChartData>: ViewModifier where ChartData: CTChartData & Touchable {
    
    var chartData: ChartData
    var minDistance: CGFloat
    
    internal func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
                    .onChanged {
                        chartData.touchObject.touchLocation = $0.location
                        chartData.touchObject.isTouch = true
                        chartData.processTouchInteraction(touchLocation: $0.location, chartSize: chartData.stateObject.chartSize)
                    }
                    .onEnded { _ in
                        chartData.touchObject.isTouch = false
                        chartData.touchDidFinish()
                    }
            )
    }
}
#endif
