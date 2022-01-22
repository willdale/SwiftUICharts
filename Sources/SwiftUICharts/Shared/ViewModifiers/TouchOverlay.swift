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
        markerType: ChartData.Marker = ChartData.defualtTouchMarker,
        minDistance: CGFloat = 0,
        location: @escaping ((Touch) -> Void)
    ) -> some View {
        #if !os(tvOS)
        self.modifier(TouchOverlay(chartData: chartData,
                                   markerType: markerType,
                                   minDistance: minDistance,
                                   location: location))
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}

public enum Touch {
    case touch(location: CGPoint)
    case off
}

#if !os(tvOS)
/**
 Finds the nearest data point and displays the relevent information.
 */
internal struct TouchOverlay<ChartData>: ViewModifier where ChartData: CTChartData & Touchable {
    
    @ObservedObject var chartData: ChartData
    var markerType: ChartData.Marker
    var minDistance: CGFloat
    var location: (Touch) -> Void
    
    @State private var touchLocation: CGPoint = .zero
    @State private var isTouch = false
    @State private var markerData = MarkerData()
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
                .gesture(
                    _ChartDragGesture(touchLocation: $touchLocation, isTouch: $isTouch, minDistance: minDistance) {
                        switch $0 {
                        case .started:
                            chartData.processTouchInteraction(&markerData, touchLocation: touchLocation)
                            location(.touch(location: touchLocation))
                        case .ended:
                            chartData.touchDidFinish()
                            location(.off)
                        }
                    }
                )
            if isTouch {
                _MarkerData(markerData: markerData, chartSize: chartData.chartSize, touchLocation: touchLocation)
            }
        }
    }
}
#endif

fileprivate struct _MarkerData: View {
    
    private(set) var markerData: MarkerData
    private(set) var chartSize: CGRect
    private(set) var touchLocation: CGPoint
    
    var body: some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                MarkerView.bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                MarkerView.line(lineMarker: marker.markerType,
                                markerData: marker,
                                chartSize: chartSize,
                                touchLocation: touchLocation,
                                dataPoints: marker.dataPoints,
                                lineType: marker.lineType,
                                lineSpacing: marker.lineSpacing,
                                minValue: marker.minValue,
                                range: marker.range)
            }
        }
    }
}

// MARK: - Gesture
fileprivate struct _ChartDragGesture: Gesture {
   
    @Binding var touchLocation: CGPoint
    @Binding var isTouch: Bool
    let minDistance: CGFloat
    let state: (State) -> Void
    
    var body: some Gesture {
        DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
            .onChanged {
                touchLocation = $0.location
                isTouch = true
                state(.started)
            }
            .onEnded { _ in
                state(.ended)
                isTouch = false
            }
    }
    
    enum State {
        case started, ended
    }
}

// MARK: - Deprecated API
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
                                   minDistance: minDistance, location: { _ in }))
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}
