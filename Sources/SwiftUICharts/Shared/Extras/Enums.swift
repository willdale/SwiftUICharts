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
 
 - Tag: CalculationType
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
 The type of `DataSet` being used
 ```
 case single // Single data set - i.e LineDataSet
 case multi // Multi data set - i.e MultiLineDataSet
 ```
 
 - Tag: DataSetType
 */
public enum DataSetType {
    case single
    case multi
}

/**
 The type of chart being used.
 ```
 case line // Line Chart Type
 case bar // Bar Chart Type
 case pie // Pie Chart Type
 ```
 
 - Tag: ChartType
 */
public enum ChartType {
    /// Line Chart Type
    case line
    /// Bar Chart Type
    case bar
    /// Pie Chart Type
    case pie
}

// MARK: - Style
/**
 Type of colour styling.
 ```
 case colour // Single Colour
 case gradientColour // Colour Gradient
 case gradientStops // Colour Gradient with stop control
 ```
 
 - Tag: ColourType
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
 
 - Tag: LineType
 */
public enum LineType {
    /// Straight line from point to point
    case line
    /// Dual control point curved line
    case curvedLine
}

/**
 Where to start drawing the line chart from.
 ```
 case minimumValue // Lowest value in the data set(s)
 case minimumWithMaximum(of: Double) // Set a custom baseline
 case zero // Set 0 as the lowest value
 ```
 
 - Tag: Baseline
 */
public enum Baseline {
    /// Lowest value in the data set(s)
    case minimumValue
    /// Set a custom baseline
    case minimumWithMaximum(of: Double)
    /// Set 0 as the lowest value
    case zero
}

// MARK: - BarStyle
/**
 Where to get the colour data from.
 ```
 case barStyle // From BarStyle data model
 case dataPoints // From each data point
 ```
 
 - Tag: ColourFrom
 */
public enum ColourFrom {
    case barStyle
    case dataPoints
}

// MARK: - TouchOverlay
/**
 Placement of the data point information panel when touch overlay modifier is applied.
 ```
 case floating // Follows input across the chart
 case header // Fix in the Header box. Must have .headerBox()
 ```
 
 - Tag: InfoBoxPlacement
 */
public enum InfoBoxPlacement {
    /// Follows input across the chart
    case floating
    /// Fix in the Header box. Must have .headerBox()
    case header
}

/**
 Where the marker lines come from to meet at a specified point.
 ```
 case fullWidth // Full width and height of view intersecting at touch location
 case bottomLeading // From bottom and leading edges meeting at touch location
 case bottomTrailing // From bottom and trailing edges meeting at touch location
 case topLeading // From top and leading edges meeting at touch location
 case topTrailing // From top and trailing edges meeting at touch location
 ```
 
 - Tag: MarkerType
 */
public enum MarkerType {
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
 
 - Tag: PointType
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
 
 - Tag: PointShape
 */
public enum PointShape {
    /// Circle Shape
    case circle
    /// Square Shape
    case square
    /// Rounded Square Shape
    case roundSquare
}

// MARK: - XAxisLabels
/**
Location of the X axis labels
 ```
 case top
 case bottom
 ```
 
 - Tag: XAxisLabelPosistion
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
 
 - Tag: LabelsFrom
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
 
 - Tag: YAxisLabelPosistion
 */
public enum YAxisLabelPosistion {
    case leading
    case trailing
}
