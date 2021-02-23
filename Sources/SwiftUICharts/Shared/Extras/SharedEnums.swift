//
//  Enums.swift
//  
//
//  Created by Will Dale on 10/01/2021.
//

import Foundation

// MARK: - ChartViewData
/**
 The type of `DataSet` being used
 ```
 case single // Single data set - i.e LineDataSet
 case multi // Multi data set - i.e MultiLineDataSet
 ```
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
 case floating // Follows input across the chart.
 case fixed // Centered in view.
 case header // Fix in the Header box. Must have .headerBox().
 ```
 */
public enum InfoBoxPlacement {
    /// Follows input across the chart.
    case floating
    /// Centered in view.
    case fixed
    /// Fix in the Header box. Must have .headerBox().
    case header
}
