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
