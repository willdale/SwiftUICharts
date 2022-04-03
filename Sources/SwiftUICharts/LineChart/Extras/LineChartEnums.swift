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
 Where the Y and X touch markers should attach themselves to.
 ```
 case line(dot: Dot) // Attached to the line.
 case point // Attached to the data points.
 ```
 */
public enum MarkerAttachment: Hashable {
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
 case vertical(attachment: MarkerAttachment) // Vertical line from top to bottom.
 case full(attachment: MarkerAttachment) // Full width and height of view intersecting at a specified point.
 case bottomLeading(attachment: MarkerAttachment) // From bottom and leading edges meeting at a specified point.
 case bottomTrailing(attachment: MarkerAttachment) // From bottom and trailing edges meeting at a specified point.
 case topLeading(attachment: MarkerAttachment) // From top and leading edges meeting at a specified point.
 case topTrailing(attachment: MarkerAttachment) // From top and trailing edges meeting at a specified point.
 ```
 */
public enum LineMarkerType: Hashable {
    /// No overlay markers.
    case none
    /// Dot that follows the path.
    case indicator(style: DotStyle)
    /// Vertical line from top to bottom.
    case vertical(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// Full width and height of view intersecting at a specified point.
    case full(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and leading edges meeting at a specified point.
    case bottomLeading(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From bottom and trailing edges meeting at a specified point.
    case bottomTrailing(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and leading edges meeting at a specified point.
    case topLeading(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
    /// From top and trailing edges meeting at a specified point.
    case topTrailing(attachment: MarkerAttachment, colour: Color = Color.primary, style: StrokeStyle = StrokeStyle())
}

/**
 Whether or not to show a dot on the line
 
 ```
 case none // No Dot
 case style(_ style: DotStyle) // Adds a dot the line at point of touch.
 ```
 */
public enum Dot: Hashable {
    /// No Dot
    case none
    /// Adds a dot the line at point of touch.
    case style(_ style: DotStyle)
}
