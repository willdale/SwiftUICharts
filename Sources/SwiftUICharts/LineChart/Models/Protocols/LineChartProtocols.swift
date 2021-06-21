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
    associatedtype Points: View
    
    /// A type representing opaque View
    associatedtype Access: View
    
    /**
     Displays Shapes over the data points.
     
     - Returns: Relevent view containing point markers based the chosen parameters.
     */
    func getPointMarker() -> Points
    
    /**
     Ensures that line charts have an accessibility layer.
     
     - Returns: A view with invisible rectangles over the data point.
     */
    func getAccessibility() -> Access
}

// MARK: - Style
/**
 A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Line Charts.
 */
public protocol CTLineChartStyle: CTLineBarChartStyle {}

/**
 Protocol to set up the styling for individual lines.
 */
public protocol CTLineStyle {
    /// Drawing style of the line.
    var lineType: LineType { get set }
    
    /// Colour styling of the line.
    var lineColour: ColourStyle { get set }
    
    /**
     Styling for stroke 
     
     Replica of Apple’s StrokeStyle that conforms to Hashable
     */
    var strokeStyle: Stroke { get set }
    
    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
     
     The default is false.
     */
    var ignoreZero: Bool { get set }
}

/**
 A protocol to extend functionality of `CTLineStyle` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineStyle: CTLineStyle {
    /// Drawing style of the range fill.
    var fillColour: ColourStyle { get set }
}



// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Line Charts.
 */
public protocol CTLineChartDataSet: CTSingleDataSetProtocol {
    
    /// A type representing colour styling
    associatedtype Styling: CTLineStyle
    
    /**
     Label to display in the legend.
     */
    var legendTitle: String { get set }
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style: Styling { get set }
    
    /**
     Sets the look of the markers over the data points.
     
     The markers are layed out when the ViewModifier `PointMarkers`
     is applied.
     */
    var pointStyle: PointStyle { get set }
}

/**
 A protocol to extend functionality of `CTLineChartDataSet` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineChartDataSet: CTLineChartDataSet {
    
    /**
     Label to display in the legend for the range area..
     */
    var legendFillTitle: String { get set }
}

/**
 A protocol to extend functionality of `CTMultiDataSetProtocol` specifically for Multi Line Charts.
 */
public protocol CTMultiLineChartDataSet: CTMultiDataSetProtocol {}



// MARK: - Data Point
/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for Line and Bar Charts.
 */
public protocol CTLineDataPointProtocol: CTLineBarDataPointProtocol {
    var pointColour: PointColour? { get set }
}

/**
 A protocol to extend functionality of `CTStandardDataPointProtocol` specifically for Ranged Line Charts.
 */
public protocol CTStandardLineDataPoint: CTLineDataPointProtocol, CTStandardDataPointProtocol, CTnotRanged {}

/**
 A protocol to extend functionality of `CTStandardDataPointProtocol` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineDataPoint: CTLineDataPointProtocol, CTStandardDataPointProtocol, CTRangeDataPointProtocol, CTisRanged {}




public protocol IgnoreMe {
    var ignoreMe: Bool { get set }
}
