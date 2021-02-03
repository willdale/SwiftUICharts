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
    private var type     : MarkerType = .fullWidth
    /// Point that the marker lines should intersect
    private var position : CGPoint
    
    internal init(type     : MarkerType = .fullWidth,
                  position : HashablePoint
    ) {
        self.type       = type
        self.position   = CGPoint(x: position.x, y: position.y)
    }
    
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
