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
internal struct TouchOverlay<T>: ViewModifier where T: ChartData {

    @ObservedObject var chartData: T
        
    internal init(chartData         : T,
                  specifier         : String
    ) {
        self.chartData = chartData
        self.chartData.infoView.touchSpecifier = specifier
    }
    
    /// Current location of the touch input
    @State private var touchLocation : CGPoint = CGPoint(x: 0, y: 0)
    /// Frame information of the data point information box
    @State private var boxFrame      : CGRect  = CGRect(x: 0, y: 0, width: 0, height: 50)
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                GeometryReader { geo in
                    ZStack {
                        content
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { (value) in
                                        touchLocation = value.location
                                                                                
                                        chartData.infoView.isTouchCurrent   = true
                                        chartData.infoView.touchOverlayInfo = chartData.getDataPoint(touchLocation: touchLocation, chartSize: geo)
                                        chartData.infoView.positionX        = setBoxLocationation(touchLocation: touchLocation, boxFrame: boxFrame, chartSize: geo).x
                                        chartData.infoView.frame            = geo.frame(in: .local)
                                        
                                    }
                                    .onEnded { _ in
                                        chartData.infoView.isTouchCurrent   = false
                                        chartData.infoView.touchOverlayInfo = []
                                    }
                            )
                        if chartData.infoView.isTouchCurrent {
                            chartData.touchInteraction(touchLocation: touchLocation, chartSize: geo)
                        }
                    }
                }
            } else { content }
        }
    }
    // MOVE TO PROTOCOL -- SEE INFOBOX
    /// Sets the point info box location while keeping it within the parent view.
    /// - Parameters:
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    internal func setBoxLocationation(touchLocation: CGPoint, boxFrame: CGRect, chartSize: GeometryProxy) -> CGPoint {

        var returnPoint : CGPoint = .zero

        if touchLocation.x < chartSize.frame(in: .local).minX + (boxFrame.width / 2) {
            returnPoint.x = chartSize.frame(in: .local).minX + (boxFrame.width / 2)
        } else if touchLocation.x > chartSize.frame(in: .local).maxX - (boxFrame.width / 2) {
            returnPoint.x = chartSize.frame(in: .local).maxX - (boxFrame.width / 2)
        } else {
            returnPoint.x = touchLocation.x
        }
        return returnPoint
    }
}
#endif

extension View {
    #if !os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Requires:
     If  LineChartStyle --> infoBoxPlacement is set to .header
     then `.headerBox` is required.
     
     If  LineChartStyle --> infoBoxPlacement is set to .fixed or . floating
     then `.infoBox` is required.
     
     - Attention:
     Unavailable in tvOS
     
     - Parameters:
        - chartData: Chart data model.
        - specifier: Decimal precision for labels.
     - Returns: A  new view containing the chart with a touch overlay.
     */
    public func touchOverlay<T: ChartData>(chartData: T,
                                           specifier: String = "%.0f"
    ) -> some View {
        self.modifier(TouchOverlay(chartData: chartData,
                                   specifier: specifier))
    }
    #elseif os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touchOverlay<T: ChartData>(chartData: T,
                                           specifier: String = "%.0f"
    ) -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}
