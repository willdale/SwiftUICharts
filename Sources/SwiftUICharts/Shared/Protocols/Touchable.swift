//
//  File.swift
//  
//
//  Created by Will Dale on 01/08/2021.
//

import SwiftUI

/// A protocol to get the correct touch overlay marker.
public protocol MarkerType {}

// MARK: - Touch
public protocol Touchable {
    
    associatedtype Marker = MarkerType
    var touchMarkerType: Marker { get set }
    static var defualtTouchMarker: Marker { get }
    
    func processTouchInteraction(_ markerData: MarkerData, touchLocation: CGPoint, chartSize: CGRect)
    
    /// Informs the data model that touch
    /// input has finished.
    func touchDidFinish()
    
    
    /**
     Takes in the required data to set up all the touch interactions.
     
     Output via `getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     */
    @available(*, deprecated, message: "Moved to \".touch\"")
    func setTouchInteraction(touchLocation: CGPoint)
    
    /// A type representing a view for the results of the touch interaction.
    associatedtype Touch: View
    
    /**
     Takes touch location and return a view based on the chart type and configuration.
     
     Inputs from `setTouchInteraction(touchLocation: CGPoint)`
     
     - Parameters:
     - touchLocation: Current location of the touch
     - chartSize: The size of the chart view as the parent view.
     - Returns: The relevent view for the chart type and options.
     */
    @available(*, deprecated, message: "Moved to \".touch\"")
    func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> Touch
}

extension Touchable where Self: LineChartType {
    public static var defualtTouchMarker: LineMarkerType { .full(attachment: .line(dot: .style(DotStyle()))) }
}

extension Touchable where Self: BarChartType {
    public static var defualtTouchMarker: BarMarkerType { .full() }
}

extension Touchable where Self: PieChartType {
    public static var defualtTouchMarker: PieMarkerType { .none }
}


extension Touchable {
    public func setTouchInteraction(touchLocation: CGPoint) {}
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
}

/*
func defualtTouchMarker(for chart: ChartName) -> MarkerType {
    switch chart {
    case .line,
         .filledLine,
         .multiLine,
         .rangedLine:
        return LineMarkerType.full(attachment: .line(dot: .style(DotStyle())))
    case .bar,
         .groupedBar,
         .rangedBar,
         .stackedBar,
         .horizontalBar:
        return BarMarkerType.full()
    case .pie,
         .doughnut:
        return PieMarkerType.none
    }
}
*/
