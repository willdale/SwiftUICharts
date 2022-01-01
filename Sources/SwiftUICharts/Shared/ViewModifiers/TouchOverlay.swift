//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

#if !os(tvOS)
/**
 Finds the nearest data point and displays the relevent information.
 */
internal struct TouchOverlay<ChartData>: ViewModifier where ChartData: CTChartData & Touchable {
    
    @ObservedObject private var chartData: ChartData
    let minDistance: CGFloat
    
    internal init(
        chartData: ChartData,
        specifier: String,
        unit: TouchUnit,
        minDistance: CGFloat
    ) {
        self.chartData = chartData
        self.minDistance = minDistance
        self.chartData.infoView.touchSpecifier = specifier
        self.chartData.infoView.touchUnit = unit
    }
    
    internal func body(content: Content) -> some View {
        Group {
            GeometryReader { geo in
                ZStack {
                    content
                        .gesture(
                            DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
                                .onChanged { value in
                                    chartData.setTouchInteraction(touchLocation: value.location,
                                                                  chartSize: geo.frame(in: .local))
                                }
                                .onEnded { _ in
                                    chartData.touchDidFinish()
                                }
                        )
                    if chartData.infoView.isTouchCurrent {
                        chartData.getTouchInteraction(touchLocation: chartData.infoView.touchLocation,
                                                      chartSize: geo.frame(in: .local))
                    }
                    
                }
            }
        }
    }
}
#endif

extension View {
    #if !os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Requires:
     If  ChartStyle --> infoBoxPlacement is set to .header
     then `.headerBox` is required.
     
     If  ChartStyle --> infoBoxPlacement is set to .infoBox
     then `.infoBox` is required.
     
     If  ChartStyle --> infoBoxPlacement is set to .floating
     then `.floatingInfoBox` is required.
     
     - Attention:
     Unavailable in tvOS
     
     - Parameters:
        - chartData: Chart data model.
        - specifier: Decimal precision for labels.
        - unit: Unit to put before or after the value.
        - minDistance: The distance that the touch event needs to travel to register.
     - Returns: A  new view containing the chart with a touch overlay.
     */
    public func touchOverlay<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        specifier: String = "%.0f",
        unit: TouchUnit = .none,
        minDistance: CGFloat = 0
    ) -> some View {
        self.modifier(TouchOverlay(chartData: chartData,
                                   specifier: specifier,
                                   unit: unit,
                                   minDistance: minDistance))
    }
    #elseif os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touchOverlay<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        specifier: String = "%.0f",
        unit: TouchUnit = .none,
        minDistance: CGFloat = 0
    ) -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}
