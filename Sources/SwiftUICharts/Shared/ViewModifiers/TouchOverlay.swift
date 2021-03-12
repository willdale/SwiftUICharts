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
internal struct TouchOverlay<T>: ViewModifier where T: CTChartData {

    @ObservedObject var chartData: T
        
    internal init(chartData : T,
                  specifier : String,
                  unit      : TouchUnit
    ) {
        self.chartData = chartData
        self.chartData.infoView.touchSpecifier = specifier
        self.chartData.infoView.touchUnit = unit
    }
        
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                GeometryReader { geo in
                    ZStack {
                        content
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { (value) in
                                        chartData.setTouchInteraction(touchLocation: value.location,
                                                                      chartSize: geo.frame(in: .local))
                                    }
                                    .onEnded { _ in
                                        chartData.infoView.isTouchCurrent   = false
                                        chartData.infoView.touchOverlayInfo = []
                                    }
                            )
                        if chartData.infoView.isTouchCurrent {
                            chartData.getTouchInteraction(touchLocation: chartData.infoView.touchLocation,
                                                          chartSize: geo.frame(in: .local))
                        }
                    }
                }
            } else { content }
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
     - Returns: A  new view containing the chart with a touch overlay.
     */
    public func touchOverlay<T: CTChartData>(chartData: T,
                                             specifier: String = "%.0f",
                                             unit     : TouchUnit = .none
    ) -> some View {
        self.modifier(TouchOverlay(chartData: chartData,
                                   specifier: specifier,
                                   unit     : unit))
    }
    #elseif os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touchOverlay<T: CTChartData>(chartData: T,
                                             specifier: String = "%.0f",
                                             unit     : TouchUnit
    ) -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}
