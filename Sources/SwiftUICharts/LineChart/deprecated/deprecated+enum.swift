//
//  deprecated+enum.swift
//  
//
//  Created by Will Dale on 27/01/2022.
//

import Foundation

/**
 Style of the point marks
 ```
 case filled // Just fill
 case outline // Just stroke
 case filledOutLine // Both fill and stroke
 ```
 */
@available(*, deprecated, message: "Please use \".pointMarkers\" instead")
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
@available(*, deprecated, message: "Please use \".pointMarkers\" instead")
public enum PointShape {
    /// Circle Shape
    case circle
    /// Square Shape
    case square
    /// Rounded Square Shape
    case roundSquare
}
