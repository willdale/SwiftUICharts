//
//  LineChartEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import Foundation

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

/**
 Where the Y and X touch markers should attach themselves to.
 ```
 case line // Attached to the line.
 case point // Attached to the data points.
 ```
 
 - Tag: MarkerAttachemnt
 */
public enum MarkerAttachemnt {
    /// Attached to the line.
    case line(dot: Dot)
    /// Attached to the data points.
    case point
}

/**
 Where the marker lines come from to meet at a specified point.
 ```
 case none // No overlay markers.
 case indicator // Rounded rectangle.
 case vertical // Vertical line from top to bottom.
 case full // Full width and height of view intersecting at touch location.
 case bottomLeading // From bottom and leading edges meeting at touch location.
 case bottomTrailing // From bottom and trailing edges meeting at touch location.
 case topLeading // From top and leading edges meeting at touch location.
 case topTrailing // From top and trailing edges meeting at touch location.

 ```
 
 - Tag: LineMarkerType
 */
public enum LineMarkerType: MarkerType {
    /// No overlay markers.
    case none
    /// Rounded rectangle.
    case indicator(style: DotStyle)
    /// Vertical line from top to bottom.
    case vertical(attachment: MarkerAttachemnt)
    /// Full width and height of view intersecting at a specified point.
    case full(attachment: MarkerAttachemnt)
    /// From bottom and leading edges meeting at a specified point.
    case bottomLeading(attachment: MarkerAttachemnt)
    /// From bottom and trailing edges meeting at a specified point.
    case bottomTrailing(attachment: MarkerAttachemnt)
    /// From top and leading edges meeting at a specified point.
    case topLeading(attachment: MarkerAttachemnt)
    /// From top and trailing edges meeting at a specified point.
    case topTrailing(attachment: MarkerAttachemnt)
}

/**
 Whether or not to show a dot on the line
 
 ```
 case none // No Dot
 case style(_ style: DotStyle) // Adds a dot the line at point of touch.
 ```
 
 - Tag: Dot
 */
public enum Dot {
    /// No Dot
    case none
    /// Adds a dot the line at point of touch.
    case style(_ style: DotStyle)
}
