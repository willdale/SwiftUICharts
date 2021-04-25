//
//  BarChartEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

/**
 Where to get the colour data from.
 ```
 case barStyle // From BarStyle data model
 case dataPoints // From each data point
 ```
 */
public enum ColourFrom {
    /// From BarStyle data model
    case barStyle
    /// From each data point
    case dataPoints
}


/**
 Where the marker lines come from to meet at a specified point.
 ```
 case none // No overlay markers.
 case vertical // Vertical line from top to bottom.
 case full // Full width and height of view intersecting at a specified point.
 case bottomLeading // From bottom and leading edges meeting at a specified point.
 case bottomTrailing // From bottom and trailing edges meeting at a specified point.
 case topLeading // From top and leading edges meeting at a specified point.
 case topTrailing // From top and trailing edges meeting at a specified point.
 ```
 */
public enum BarMarkerType: MarkerType {
    /// No overlay markers.
    case none
    /// Vertical line from top to bottom.
    case vertical(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// Full width and height of view intersecting at a specified point.
    case full(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and leading edges meeting at a specified point.
    case bottomLeading(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and trailing edges meeting at a specified point.
    case bottomTrailing(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and leading edges meeting at a specified point.
    case topLeading(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and trailing edges meeting at a specified point.
    case topTrailing(colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
}
