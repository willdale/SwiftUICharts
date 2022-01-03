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
        markerType: ChartData.Marker,
        minDistance: CGFloat
    ) {
        self.chartData = chartData
        self.minDistance = minDistance
        
        self.chartData.touchMarkerType = markerType
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
    
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touch<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        markerType: ChartData.Marker = ChartData.defualtTouchMarker,
        minDistance: CGFloat = 0
    ) -> some View {
        #if !os(tvOS)
        self.modifier(TouchOverlay(chartData: chartData,
                                   markerType: markerType,
                                   minDistance: minDistance))
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}

extension View {
    
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Attention:
     Unavailable in tvOS
     */
    @available(*, deprecated, message: "Please use \".touch\" instead")
    public func touchOverlay<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        specifier: String = "%.0f",
        unit: TouchUnit = .none,
        minDistance: CGFloat = 0
    ) -> some View {
        #if !os(tvOS)
        self.modifier(TouchOverlay(chartData: chartData,
                                   markerType: ChartData.defualtTouchMarker,
                                   minDistance: minDistance))
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}
