//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

#if !os(tvOS)
/// Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information.
internal struct TouchOverlay: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    /// Decimal precision for labels
    private let specifier               : String
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
    @State private var boxFrame         : CGRect    = CGRect(x: 0, y: 0, width: 0, height: 50)
    /// Placement of the data point information box
    @State private var boxLocation      : CGPoint   = CGPoint(x: 0, y: 0)
    /// Placement of place the markers intersecting the data points location
    @State private var markerLocation   : CGPoint   = CGPoint(x: 0, y: 0)
    
    /// Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information.
    /// - Parameters:
    ///   - specifier: Decimal precision for labels
    ///   - infoBoxPlacement: Placement of the data point information panel when touch overlay modifier is applied.
    internal init(specifier: String) {
        self.specifier = specifier
    }
    
    @ViewBuilder internal func body(content: Content) -> some View {
        if chartData.dataPoints.count > 2 {
            GeometryReader { geo in
                ZStack {
                    content
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { (value) in
                                    touchLocation   = value.location
                                    isTouchCurrent  = true
                                    
                                    switch chartData.viewData.chartType {
                                    case .line:
                                        getPointLocationLineChart(touchLocation: touchLocation, chartSize: geo)
                                        getDataPointLineChart(touchLocation: touchLocation, chartSize: geo)
                                    case .bar:
                                        getPointLocationBarChart(touchLocation: touchLocation, chartSize: geo)
                                        getDataPointBarChart(touchLocation: touchLocation, chartSize: geo)
                                    }
                                    
                                    if chartData.chartStyle.infoBoxPlacement == .floating {
                                        setBoxLocationation(boxFrame: boxFrame, chartSize: geo)
                                        markerLocation.x = setMarkerXLocation(chartSize: geo)
                                        markerLocation.y = setMarkerYLocation(chartSize: geo)
                                    } else if chartData.chartStyle.infoBoxPlacement == .header {
                                        chartData.chartStyle.infoBoxPlacement = .header
                                        chartData.viewData.isTouchCurrent   = true
                                        chartData.viewData.touchOverlayInfo = selectedPoint
                                    }
                                }
                                .onEnded { _ in
                                    isTouchCurrent = false
                                    chartData.viewData.isTouchCurrent = false
                                }
                        )
                    if isTouchCurrent {
                        TouchOverlayMarker(position: pointLocation)
                            .stroke(Color(.gray), lineWidth: touchMarkerLineWidth)
                        if chartData.chartStyle.infoBoxPlacement == .floating, let lineChartStyle = chartData.lineStyle {
                            TouchOverlayBox(selectedPoint: selectedPoint, specifier: specifier, boxFrame: $boxFrame, ignoreZero: lineChartStyle.ignoreZero)
                                .position(x: boxLocation.x, y: 0 + (boxFrame.height / 2))
                        }
                    }
                }
            }
        } else { content }
    }
    
    // MARK: - Bar Chart
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getDataPointLineChart(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> ChartDataPoint */ {
        let dataPoints  : [ChartDataPoint]  = chartData.dataPoints
        let xSection    : CGFloat           = chartSize.size.width / CGFloat(dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataPoints.count {
            self.selectedPoint = dataPoints[index]
        }
    }
    /// Gets the location of the data point in the view. For Line Chart
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getPointLocationLineChart(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> CGPoint */ {
        
        let minValue : Double
        let range    : Double
        
        switch chartData.lineStyle.baseline {
        case .minimumValue:
            minValue = chartData.minValue()
            range    = chartData.range()
        case .zero:
            minValue = 0
            range    = chartData.maxValue()
        }
        
        let dataPointCount : Int = chartData.dataPoints.count
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataPointCount - 1)
        let ySection : CGFloat = chartSize.size.height / CGFloat(range)
        let index = Int((touchLocation.x + (xSection / 2)) / xSection)
        
        if index >= 0 && index < dataPointCount {
            if !chartData.lineStyle.ignoreZero {
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
    
    // MARK: - Bar Chart
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getDataPointBarChart(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> ChartDataPoint */ {
        let dataPoints  : [ChartDataPoint]  = chartData.dataPoints
        let xSection    : CGFloat           = chartSize.size.width / CGFloat(dataPoints.count)
        let index       : Int               = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataPoints.count {
            self.selectedPoint = dataPoints[index]
        }
    }
    
    /// Gets the location of the data point in the view. For BarChart
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getPointLocationBarChart(touchLocation: CGPoint, chartSize: GeometryProxy) /* -> CGPoint */ {
        
        let dataPointCount : Int = chartData.dataPoints.count
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataPointCount)
        let ySection : CGFloat = chartSize.size.height / CGFloat(chartData.maxValue())
        
        let index = Int((touchLocation.x) / xSection)
        
        if index >= 0 && index < dataPointCount {
            self.pointLocation = CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                         y: (chartSize.size.height - CGFloat(chartData.dataPoints[index].value) * ySection))
        }
    }
    
    // MARK: - Both
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
#endif

extension View {
    #if !os(tvOS)
    /// Adds an overlay to detect touch and display the relivent information from the nearest data point.
    /// - Parameter specifier: Decimal precision for labels
    public func touchOverlay(specifier: String = "%.0f") -> some View {
        self.modifier(TouchOverlay(specifier: specifier))
    }
    #elseif os(tvOS)
    public func touchOverlay(specifier: String = "%.0f") -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
    
}

