//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

#if !os(tvOS)
/// Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information.
internal struct TouchOverlay<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData: T
    
    /// Decimal precision for labels
    private let specifier               : String
    private let touchMarkerLineWidth    : CGFloat = 1 // API?
    
    /// Boolean that indicates whether touch is currently being detected
    @State private var isTouchCurrent   : Bool      = false
    /// Current location of the touch input
    @State private var touchLocation    : CGPoint   = CGPoint(x: 0, y: 0)
    /// The data point closest to the touch input
    @State private var selectedPoints   : [ChartDataPoint] = []
    /// The location for the nearest data point to the touch input
    @State private var pointLocations   : [HashablePoint]  = [HashablePoint(x: 0, y: 0)]
    /// Frame information of the data point information box
    @State private var boxFrame         : CGRect    = CGRect(x: 0, y: 0, width: 0, height: 50)
    /// Placement of the data point information box
    @State private var boxLocation      : CGPoint   = CGPoint(x: 0, y: 0)
    /// Placement of place the markers intersecting the data points location
    @State private var markerLocation   : CGPoint   = CGPoint(x: 0, y: 0)
    
    /// Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information.
    /// - Parameters:
    ///   - chartData:
    ///   - specifier: Decimal precision for labels
    internal init(chartData: T,
                  specifier: String
    ) {
        self.chartData = chartData
        self.specifier = specifier
    }
    
    internal func body(content: Content) -> some View {
//        if chartData.isGreaterThanTwo {
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
                                        getPointLocationLineChart(dataSets      : chartData.dataSets,
                                                                  touchLocation : touchLocation,
                                                                  chartSize     : geo)
                                        getDataPointLineChart(dataSets      : chartData.dataSets,
                                                              touchLocation : touchLocation,
                                                              chartSize     : geo)
                                    case .bar:
                                        getPointLocationBarChart(dataSets: chartData.dataSets,
                                                                 touchLocation: touchLocation,
                                                                 chartSize: geo)
                                        getDataPointBarChart(dataSets: chartData.dataSets,
                                                             touchLocation: touchLocation,
                                                             chartSize: geo)
                                    }
                                    
                                    if chartData.chartStyle.infoBoxPlacement == .floating {
                                        setBoxLocationation(boxFrame: boxFrame, chartSize: geo)
                                        markerLocation.x = setMarkerXLocation(chartSize: geo)
                                        markerLocation.y = setMarkerYLocation(chartSize: geo)
                                    } else if chartData.chartStyle.infoBoxPlacement == .header {
                                        chartData.viewData.isTouchCurrent   = true
                                        chartData.viewData.touchOverlayInfo = selectedPoints
                                    }
                                }
                                .onEnded { _ in
                                    isTouchCurrent = false
                                    chartData.viewData.isTouchCurrent = false
                                }
                        )
                    if isTouchCurrent {
                        ForEach(pointLocations, id: \.self) { location in
                            TouchOverlayMarker(position: location)
                                .stroke(Color(.gray), lineWidth: touchMarkerLineWidth)
                        }
                        if chartData.chartStyle.infoBoxPlacement == .floating {
                            TouchOverlayBox(selectedPoints: selectedPoints, specifier: specifier, boxFrame: $boxFrame)
                                .position(x: boxLocation.x, y: 0 + (boxFrame.height / 2))
                        }
                    }
                }
            }
//        } else { content }
    }
    
    // MARK: - Line Chart
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getDataPointLineChart<U: DataSet>(dataSets       : [U],
                                                    touchLocation : CGPoint,
                                                    chartSize     : GeometryProxy)  { // -> [ChartDataPoint]
        var points : [ChartDataPoint] = []
        for dataSet in dataSets {
            let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[index])
            }
        }
        self.selectedPoints = points
    }
    /// Gets the location of the data point in the view. For Line Chart
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getPointLocationLineChart<U: DataSet>(dataSets: [U],
                                                        touchLocation: CGPoint,
                                                        chartSize: GeometryProxy) { // -> CGPoint
        
        let range    = DataFunctions.dataSetRange(from: dataSets)
        let minValue = DataFunctions.dataSetMinValue(from: dataSets)
        
        var locations : [HashablePoint] = []
        for dataSet in dataSets {
           
            let dataPointCount : Int = dataSet.dataPoints.count
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataPointCount - 1)
            let ySection : CGFloat = chartSize.size.height / CGFloat(range)
            let index = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataPointCount {
                locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                               y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.size.height))
            }
        }
        self.pointLocations = locations
    }
    
    // MARK: - Bar Chart
    /// Gets the nearest data point to the touch location based on the X axis.
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getDataPointBarChart<U: DataSet>(dataSets       : [U],
                                                   touchLocation : CGPoint,
                                                   chartSize     : GeometryProxy)  { // -> [ChartDataPoint]
        var points : [ChartDataPoint] = []
        for dataSet in dataSets {
            let xSection    : CGFloat   = chartSize.size.width / CGFloat(dataSet.dataPoints.count)
            let index       : Int       = Int((touchLocation.x) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[index])
            }
        }
        self.selectedPoints = points
    }
    
    /// Gets the location of the data point in the view. For BarChart
    /// - Parameters:
    ///   - touchLocation: Current location of the touch
    ///   - chartSize: The size of the chart view as the parent view.
    internal func getPointLocationBarChart<U: DataSet>(dataSets: [U],
                                                       touchLocation: CGPoint,
                                                       chartSize: GeometryProxy) { // -> CGPoint
        var locations : [HashablePoint] = []
        for dataSet in dataSets {
            let dataPointCount : Int = dataSet.dataPoints.count
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataPointCount)
            let ySection : CGFloat = chartSize.size.height / CGFloat(DataFunctions.dataSetMaxValue(from: dataSets))
            
            let index = Int((touchLocation.x) / xSection)
            
            if index >= 0 && index < dataPointCount {
                locations.append(HashablePoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                               y: (chartSize.size.height - CGFloat(dataSet.dataPoints[index].value) * ySection)))
            }
        }
        self.pointLocations = locations
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
    public func touchOverlay<T: ChartData>(chartData: T, specifier: String = "%.0f") -> some View {
        self.modifier(TouchOverlay(chartData: chartData, specifier: specifier))
    }
    #elseif os(tvOS)
    public func touchOverlay(specifier: String = "%.0f") -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}


public struct HashablePoint: Hashable {
    
   public let x : CGFloat
   public let y : CGFloat
    
    public init(x: CGFloat, y: CGFloat) {
        self.x = x
        self.y = y
    }
}
