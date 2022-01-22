//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI


public final class TestStateObject: ObservableObject {
    @Published public var chartSize: CGRect = .zero
    @Published public var leadingInset: CGFloat = 0
    @Published public var touchLocation: CGPoint = .zero
    @Published public var isTouch: Bool = false
    
    public init() {}
    
    public enum Touch {
        case touch(location: CGPoint)
        case off
    }
}


// MARK: - API
extension View {
    
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touch<ChartData: CTChartData & Touchable>(
        stateObject: TestStateObject,
        chartData: ChartData,
        markerType: ChartData.Marker = ChartData.defualtTouchMarker,
        minDistance: CGFloat = 0
    ) -> some View {
        #if !os(tvOS)
        self.modifier(TouchOverlay(stateObject: stateObject,
                                   chartData: chartData,
                                   markerType: markerType,
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
    
    @ObservedObject var stateObject: TestStateObject
    @ObservedObject var chartData: ChartData
    var markerType: ChartData.Marker
    var minDistance: CGFloat
    
    @State private var markerData = MarkerData()
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
                .gesture(
                    _ChartDragGesture(stateObject: stateObject, minDistance: minDistance) {
                        switch $0 {
                        case .started:
                            chartData.processTouchInteraction(&markerData, touchLocation: stateObject.touchLocation)
                        case .ended:
                            chartData.touchDidFinish()
                        }
                    }
                )
            if stateObject.isTouch {
                _MarkerData(markerData: markerData, chartSize: chartData.chartSize, touchLocation: stateObject.touchLocation)
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
   
    @ObservedObject var stateObject: TestStateObject
    let minDistance: CGFloat
    let state: (State) -> Void
    
    var body: some Gesture {
        DragGesture(minimumDistance: minDistance, coordinateSpace: .local)
            .onChanged {
                stateObject.touchLocation = $0.location
                stateObject.isTouch = true
                state(.started)
            }
            .onEnded { _ in
                stateObject.isTouch = false
                state(.ended)
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
        self.modifier(EmptyModifier())
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}
