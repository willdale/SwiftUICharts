//
//  Enums.swift
//  
//
//  Created by Will Dale on 10/01/2021.
//

import Foundation


// MARK: - DataPoints
/**
 Inbuild functions for manipulating the datapoints before drawing the chart.
 ```
 case none // No function
 case averageMonth // Monthly Average
 case averageWeek // Weekly Average
 case averageDay // Daily Average
 ```
 */
public enum CalculationType {
    /// No function
    case none
    /// Monthly Average
    case averageMonth
    /// Weekly Average
    case averageWeek
    /// Daily Average
    case averageDay
}

// MARK: - ChartViewData
/**
 Pass the type of chart being used to view modifiers.
 ```
 case line // Line Chart Type
 case bar // Bar Chart Type
 ```
 */
public enum ChartType {
    /// Line Chart Type
    case line
    /// Bar Chart Type
    case bar
}

// MARK: - Style
/**
 Type of colour styling for the chart.
 ```
 case colour // Single Colour
 case gradientColour // Colour Gradient
 case gradientStops // Colour Gradient with stop control
 ```
 */
public enum ColourType {
    /// Single Colour
    case colour
    /// Colour Gradient
    case gradientColour
    /// Colour Gradient with stop control
    case gradientStops
}

// MARK: - LineShape
/**
 Drawing style of the line
 ```
 case line // Straight line from point to point
 case curvedLine // Dual control point curved line
 ```
 */
public enum LineType {
    /// Straight line from point to point
    case line
    /// Dual control point curved line
    case curvedLine
}

// MARK: - BarStyle
/**
 Where to get the colour data from.
 ```
 case barStyle // From BarStyle data model
 case dataPoints // From each data point
 ```
 */
public enum ColourFrom {
    case barStyle
    case dataPoints
}

// MARK: - TouchOverlayMarker
/**
 Where the marker lines come from to meet at a specified point.
 ```
 case fullWidth // Full width and height of view intersecting at touch location
 case bottomLeading // From bottom and leading edges meeting at touch location
 case bottomTrailing // From bottom and trailing edges meeting at touch location
 case topLeading // From top and leading edges meeting at touch location
 case topTrailing // From top and trailing edges meeting at touch location
 ```
 */
public enum MarkerLineType {
    /// Full width and height of view intersecting at a specified point
    case fullWidth
    /// From bottom and leading edges meeting at a specified point
    case bottomLeading
    /// From bottom and trailing edges meeting at a specified point
    case bottomTrailing
    /// From top and leading edges meeting at a specified point
    case topLeading
    /// From top and trailing edges meeting at a specified point
    case topTrailing
}

// MARK: - PointMarkers
/**
 Style of the point marks
 ```
 case filled // Just fill
 case outline // Just stroke
 case filledOutLine // Both fill and stroke
 ```
 */
public enum PointType {
    /// Just fill
    case filled
    /// Just stroke
    case outline
    /// Both fill and stroke
    case filledOutLine
}
/**
 Shape of the points
 ```
 case circle
 case square
 case roundSquare
 ```
 */
public enum PointShape {
    /// Circle Shape
    case circle
    /// Square Shape
    case square
    /// Rounded Square Shape
    case roundSquare
}

// MARK: - TouchOverlay
/**
 Placement of the data point information panel when touch overlay modifier is applied.
 ```
 case floating // Follows input across the chart
 case header // Fix in the Header box. Must have .headerBox()
 
 ```
 */
public enum InfoBoxPlacement {
    /// Follows input across the chart
    case floating
    /// Fix in the Header box. Must have .headerBox()
    case header
}

// MARK: - XAxisLabels
/**
Location of the X axis labels
 ```
 case top
 case bottom
 ```
 */
public enum XAxisLabelPosistion {
    case top
    case bottom
}
/**
 Where the label data come from.
 
 xAxisLabel comes from  ChartData --> DataPoint model.
 
 xAxisLabels comes from ChartData --> xAxisLabels
 ```
 case dataPoint // ChartData --> DataPoint --> xAxisLabel
 case chartData // ChartData --> xAxisLabels
 ```
 */
public enum LabelsFrom {
    /// ChartData --> DataPoint --> xAxisLabel
    case dataPoint
    /// ChartData --> xAxisLabels
    case chartData
}

// MARK: - YAxisLabels
/**
Location of the Y axis labels
 ```
 case leading
 case trailing
 ```
 */
public enum YAxisLabelPosistion {
    case leading
    case trailing
}

/**
 Option to display the markers' value inline with the marker..
 
 ```
 case none // No label.
 case yAxis(specifier: String) // Places the label in the yAxis labels.
 case center(specifier: String) // Places the label in the center of chart.
 ```
 */
public enum DisplayValue {
    /// No label.
    case none
    /// Places the label in the yAxis labels.
    case yAxis(specifier: String)
    /// Places the label in the center of chart.
    case center(specifier: String)
}

/**
 Option to display units before or after values.
 
 ```
 case none // No units
 case prefix(of: String) // Before value
 case suffix(of: String) // After value
 ```
 */
public enum Units {
    /// No units
    case none
    /// Before value
    case prefix(of: String)
    /// After value
    case suffix(of: String)
}
