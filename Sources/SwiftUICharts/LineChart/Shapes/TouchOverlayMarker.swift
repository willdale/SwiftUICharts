//
//  TouchOverlayMarker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Lines on the both axes (yes, apprently that is the plural of axis) meeting at a specified point.
internal struct TouchOverlayMarker: Shape {
    
    /// Where the marker lines come from to meet at a specified point
    var type     : MarkerLineType = .fullWidth
    /// Point that the marker lines should intersect
    var position : CGPoint
    
    internal func path(in rect: CGRect) -> Path {
        
        var combinedPaths   = Path()
        var horizontalPath  = Path()
        var verticalPath    = Path()
        
        switch type {
        case .fullWidth:
            horizontalPath.move(to: CGPoint(x: 0, y: position.y))
            horizontalPath.addLine(to: CGPoint(x: rect.width, y: position.y))
            verticalPath.move(to: CGPoint(x: position.x, y: 0))
            verticalPath.addLine(to: CGPoint(x: position.x, y: rect.height))
        case .bottomLeading:
            horizontalPath.move(to: CGPoint(x: 0, y: position.y))
            horizontalPath.addLine(to: CGPoint(x: position.x, y: position.y))
            verticalPath.move(to: CGPoint(x: position.x, y: rect.height))
            verticalPath.addLine(to: CGPoint(x: position.x, y: position.y))
        case .bottomTrailing:
            horizontalPath.move(to: CGPoint(x: rect.width, y: position.y))
            horizontalPath.addLine(to: CGPoint(x: position.x, y: position.y))
            verticalPath.move(to: CGPoint(x: position.x, y: rect.height))
            verticalPath.addLine(to: CGPoint(x: position.x, y: position.y))
        case .topLeading:
            horizontalPath.move(to: CGPoint(x: rect.width, y: position.y))
            horizontalPath.addLine(to: CGPoint(x: position.x, y: position.y))
            verticalPath.move(to: CGPoint(x: position.x, y: 0))
            verticalPath.addLine(to: CGPoint(x: position.x, y: position.y))
        case .topTrailing:
            horizontalPath.move(to: CGPoint(x: rect.width, y: position.y))
            horizontalPath.addLine(to: CGPoint(x: position.x, y: position.y))
            verticalPath.move(to: CGPoint(x: position.x, y: 0))
            verticalPath.addLine(to: CGPoint(x: position.x, y: position.y))
        }
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        
        return combinedPaths
    }
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
 */
public enum MarkerLineType {
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
