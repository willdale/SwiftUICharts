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
