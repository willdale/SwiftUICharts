//
//  LineChartEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

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

/**
 Where the Y and X touch markers should attach themselves to.
 ```
 case line(dot: Dot) // Attached to the line.
 case point // Attached to the data points.
 ```
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
 case indicator(style: DotStyle) // Dot that follows the path.
 case vertical(attachment: MarkerAttachemnt) // Vertical line from top to bottom.
 case full(attachment: MarkerAttachemnt) // Full width and height of view intersecting at a specified point.
 case bottomLeading(attachment: MarkerAttachemnt) // From bottom and leading edges meeting at a specified point.
 case bottomTrailing(attachment: MarkerAttachemnt) // From bottom and trailing edges meeting at a specified point.
 case topLeading(attachment: MarkerAttachemnt) // From top and leading edges meeting at a specified point.
 case topTrailing(attachment: MarkerAttachemnt) // From top and trailing edges meeting at a specified point.
 ```
 */
public enum LineMarkerType: MarkerType {
    /// No overlay markers.
    case none
    /// Dot that follows the path.
    case indicator(style: DotStyle)
    /// Vertical line from top to bottom.
    case vertical(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// Full width and height of view intersecting at a specified point.
    case full(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and leading edges meeting at a specified point.
    case bottomLeading(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and trailing edges meeting at a specified point.
    case bottomTrailing(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and leading edges meeting at a specified point.
    case topLeading(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and trailing edges meeting at a specified point.
    case topTrailing(attachment: MarkerAttachemnt, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
}

/**
 Whether or not to show a dot on the line
 
 ```
 case none // No Dot
 case style(_ style: DotStyle) // Adds a dot the line at point of touch.
 ```
 */
public enum Dot {
    /// No Dot
    case none
    /// Adds a dot the line at point of touch.
    case style(_ style: DotStyle)
}
