//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

internal struct TouchOverlay: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    /// Decimal precision for labels
    private let specifier               : String
    private var dragGesture             : DragGesture
    private let touchMarkerLineWidth    : CGFloat = 1 // API?
    
    /// Boolean that indicates whether touch is currently being detected
    @State private var isTouchCurrent   : Bool      = false
    /// Current location of the touch input
    @State private var touchLocation    : CGPoint   = CGPoint(x: 0, y: 0)
    /// The data point closest to the touch input
    @State private var selectedPoint    : ChartDataPoint?
    /// The location for the nearest data point to the touch input
    @State private var pointLocation    : CGPoint   = CGPoint(x: 0, y: 0)
    /// Frame information of the data point information box
    @State private var boxFrame         : CGRect    = .zero
    /// Placement of the data point information box
    @State private var boxLocation      : CGPoint   = CGPoint(x: 0, y: 0)
    /// Placement of place the markers intersecting the data points location
    @State private var markerLocation   : CGPoint   = CGPoint(x: 0, y: 0)
    
    internal init(specifier: String) {
        self.specifier = specifier
        self.dragGesture = DragGesture()
        self.dragGesture.minimumDistance = 0
    }
    
    internal func body(content: Content) -> some View {
        GeometryReader { geo in
            ZStack {
                content
                    .gesture(
                        dragGesture
                            .onChanged { (value) in
                                touchLocation   = value.location
                                isTouchCurrent  = true
                                getDataPoint(touchLocation: touchLocation, chartSize: geo)
                                getPointLocation(touchLocation: touchLocation, chartSize: geo)
                                setBoxLocationation(boxFrame: boxFrame, chartSize: geo)
                                markerLocation.x = setMarkerXLocation(chartSize: geo)
                                markerLocation.y = setMarkerYLocation(chartSize: geo)
                            }
                            .onEnded { _ in
                                isTouchCurrent  = false
                            }
                    )
                if isTouchCurrent {
                    TouchOverlayMarker(position: pointLocation)
                        .stroke(Color(.systemGray), lineWidth: touchMarkerLineWidth)
                    TouchOverlayBox(selectedPoint: selectedPoint, specifier: specifier, boxFrame: $boxFrame, ignoreZero: chartData.chartStyle.ignoreZero)
                        .position(x: boxLocation.x, y: -40)
                }
            }
        }
    }
    
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> ChartDataPoint */ {
        let dataPoints  : [ChartDataPoint]  = chartData.dataPoints
        let xSection    : CGFloat           = chartSize.size.width / CGFloat(dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataPoints.count {
            self.selectedPoint = dataPoints[index]
        }
    }
    
    /// Gets the location of the data point in the view.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> CGPoint */ {
        
        let range    = chartData.range()
        let minValue = chartData.minValue()
        
        let dataPointCount : Int = chartData.dataPoints.count
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataPointCount - 1)
        let ySection : CGFloat = chartSize.size.height / CGFloat(range)
        let index = Int((touchLocation.x + (xSection / 2)) / xSection)
        
        if index >= 0 && index < dataPointCount {
            if !chartData.chartStyle.ignoreZero {
                self.pointLocation = CGPoint(x: CGFloat(index) * xSection,
                                             y: (CGFloat(chartData.dataPoints[index].value - minValue) * -ySection) + chartSize.size.height)
            } else {
                var pointValue : Double
                if chartData.dataPoints[index].value == 0 {
                    if index > 0 && index < chartData.dataPoints.count - 1 {
                        // Set data point value as halfway between the previous and next value
                        pointValue = (chartData.dataPoints[index-1].value + chartData.dataPoints[index+1].value) / 2
                    } else {
                        pointValue = chartData.dataPoints[index].value
                    }
                } else {
                    pointValue = chartData.dataPoints[index].value
                }
                self.pointLocation = CGPoint(x: CGFloat(index) * xSection,
                                             y: (CGFloat(pointValue - minValue) * -ySection) + chartSize.size.height)
            }
        }
    }
    
    /// Sets the point info box location while keeping it within the parent view.
    /// - Parameters:
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    internal func setBoxLocationation(boxFrame: CGRect, chartSize: GeometryProxy) {
        if touchLocation.x < chartSize.frame(in: .local).minX + (boxFrame.width / 2) {
            boxLocation.x = chartSize.frame(in: .local).minX + (boxFrame.width / 2)
        } else if touchLocation.x > chartSize.frame(in: .local).maxX - (boxFrame.width / 2) {
            boxLocation.x = chartSize.frame(in: .local).maxX - (boxFrame.width / 2)
        } else {
            boxLocation.x = touchLocation.x
        }
    }
    /// Sets the X axis marker location while keeping it within the parent view.
    /// - Parameter chartSize: The size of the chart view as the parent view.
    /// - Returns: Position of the marker.
    internal func setMarkerXLocation(chartSize: GeometryProxy) -> CGFloat {
        if touchLocation.x < chartSize.frame(in: .local).minX {
            return chartSize.frame(in: .local).minX
        } else if touchLocation.x > chartSize.frame(in: .local).maxX {
            return chartSize.frame(in: .local).maxX
        } else {
            return touchLocation.x
        }
    }
    /// Sets the Y axis marker location while keeping it within the parent view.
    /// - Parameter chartSize: The size of the chart view as the parent view.
    /// - Returns: Position of the marker.
    internal func setMarkerYLocation(chartSize: GeometryProxy) -> CGFloat {
        if touchLocation.y < chartSize.frame(in: .local).minY {
            return chartSize.frame(in: .local).minY
        } else if touchLocation.y > chartSize.frame(in: .local).maxY {
            return chartSize.frame(in: .local).maxY
        } else {
            return touchLocation.y
        }
    }
}

extension View {
    /// Adds an overlay to detect touch and display the relivent information from the nearest data point.
    /// - Parameter specifier: Decimal precision for labels
    public func touchLocation(specifier: String = "%.0f") -> some View {
        self.modifier(TouchOverlay(specifier: specifier))
    }
}


