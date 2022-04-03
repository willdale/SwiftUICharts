//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

public protocol LineChartType {}

// MARK: - Chart Data
public protocol CTLineChartDataProtocol {}

// MARK: - Style
/// A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Line Charts.
@available(*, deprecated, message: "Has been de-centralised")
public protocol CTLineChartStyle: CTLineBarChartStyle {}

/**
 Protocol to set up the styling for individual lines.
 */
public protocol CTLineStyle {
    /// Drawing style of the line.
    var lineType: LineType { get set }
    
    /// Colour styling of the line.
    var lineColour: ChartColour { get set }
    
    /**
     Styling for stroke 
     
     Replica of Apple’s StrokeStyle that conforms to Hashable
     */
    var strokeStyle: StrokeStyle { get set }
}

/**
 A protocol to extend functionality of `CTLineStyle` specifically for Ranged Line Charts.
 */
public protocol CTRangedLineStyle: CTLineStyle {
    /// Drawing style of the range fill.
    var fillColour: ChartColour { get set }
}



// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Line Charts.
 */
public protocol CTLineChartDataSet: CTSingleDataSetProtocol {
    
    /// A type representing colour styling
    associatedtype Styling: CTLineStyle
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style: Styling { get set }
    
    /**
     Sets the look of the markers over the data points.
     
     The markers are layed out when the ViewModifier `PointMarkers`
     is applied.
     */
    @available(*, deprecated, message: "Please use \".pointMarkers\" instead")
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
    @available(*, deprecated, message: "Please use \".pointMarkers\" instead")
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




public protocol Ignorable {
    var ignore: Bool { get set }
}
