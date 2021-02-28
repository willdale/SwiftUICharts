//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTLineBarChartDataProtocol` specifically for Line Charts.
 */
public protocol CTLineChartDataProtocol: CTLineBarChartDataProtocol {

    /// A type representing opaque View
    associatedtype Marker : View
    /// A type representing opaque View
    associatedtype Points : View
    
    associatedtype Access : View
        
    /**
     Whether it is a normal or filled line.
     */
    var isFilled    : Bool { get set}
    
    /**
     Returns the position to place the indicator on the line
     based on the users touch or pointer input.
     
     - Parameters:
        - rect: Frame of the path.
        - dataPoints: Data points used to draw the chart.
        - touchLocation: Location of the touch or pointer input.
        - lineType: Drawing style of the line.
     - Returns: The position to place the indicator.
     */
    func getIndicatorLocation(rect: CGRect, dataPoints: [LineChartDataPoint], touchLocation: CGPoint, lineType: LineType) -> CGPoint

    /// Displays a view contatining touch markers.
    /// - Parameters:
    ///   - dataSet: The data set to search in.
    ///   - touchLocation: Current location of the touch.
    ///   - chartSize: The size of the chart view as the parent view.
    /// - Returns: Relevent touch marker based the chosen parameters.
    func markerSubView(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: CGRect) -> Marker
    
    /// Displays Shapes over the data points.
    /// - Returns: Relevent view containing point markers based the chosen parameters.
    func getPointMarker() -> Points
    
    func getAccessibility() -> Access
}


// MARK: - Style
/**
 A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Line Charts.
 */
public protocol CTLineChartStyle : CTLineBarChartStyle {}



// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Line Charts.
 */
public protocol CTLineChartDataSet: CTSingleDataSetProtocol {
    
    /// A type representing colour styling
    associatedtype Styling   : CTColourStyle
    
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style : Styling { get set }
    
    /**
     Sets the look of the markers over the data points.
     
     The markers are layed out when the ViewModifier `PointMarkers`
     is applied.
     */
    var pointStyle : PointStyle { get set }
}
