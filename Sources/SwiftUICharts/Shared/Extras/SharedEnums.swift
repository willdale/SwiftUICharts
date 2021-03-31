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
 case infoBox(isStatic: Bool)  // Display in the InfoBox. Must have .infoBox()
 case header // Fix in the Header box. Must have .headerBox().
 ```
 */
public enum InfoBoxPlacement {
    /// Follows input across the chart.
    case floating
    /// Display in the InfoBox. Must have .infoBox()
    case infoBox(isStatic: Bool = false)
    /// Display in the Header box. Must have .headerBox().
    case header
}


// MARK: - TouchOverlay
/**
 Alignment of the content inside of the information box
 ```
 case vertical // Puts the legend, value and description verticaly
 case horizontal // Puts the legend, value and description horizontaly
 ```
 */
public enum InfoBoxAlignment {
    case vertical
    case horizontal
}


/**
 Option to display units before or after values.
 
 ```
 case none // No unit
 case prefix(of: String) // Before value
 case suffix(of: String) // After value
 ```
 */
public enum TouchUnit {
    /// No units
    case none
    /// Before value
    case prefix(of: String)
    /// After value
    case suffix(of: String)
}
