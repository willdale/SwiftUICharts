//
//  BarChartEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import Foundation

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


/**
 Where the marker lines come from to meet at a specified point.
 ```
 case none // No overlay markers.
 case vertical // Vertical line from top to bottom.
 case full // Full width and height of view intersecting at touch location.
 case bottomLeading // From bottom and leading edges meeting at touch location.
 case bottomTrailing // From bottom and trailing edges meeting at touch location.
 case topLeading // From top and leading edges meeting at touch location.
 case topTrailing // From top and trailing edges meeting at touch location.

 ```
 
 - Tag: BarMarkerType
 */
public enum BarMarkerType: MarkerType {
    /// No overlay markers.
    case none
    /// Vertical line from top to bottom.
    case vertical
    /// Full width and height of view intersecting at a specified point.
    case full
    /// From bottom and leading edges meeting at a specified point.
    case bottomLeading
    /// From bottom and trailing edges meeting at a specified point.
    case bottomTrailing
    /// From top and leading edges meeting at a specified point.
    case topLeading
    /// From top and trailing edges meeting at a specified point.
    case topTrailing
}
