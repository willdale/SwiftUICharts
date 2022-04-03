//
//  TouchOverlayMarker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Vertical line from top to bottom.
internal struct Vertical: Shape {
    
    private let position: CGPoint
    
    internal init(position: CGPoint) {
        self.position = position
    }
    
    internal func path(in rect: CGRect) -> Path {
        var verticalPath = Path()
        verticalPath.move(to: CGPoint(x: position.x, y: 0))
        verticalPath.addLine(to: CGPoint(x: position.x,
                                         y: rect.height))
        return verticalPath
    }
}

/// Full width and height of view intersecting at a specified point.
internal struct MarkerFull: Shape {
    
    private let position: CGPoint
    
    internal init(position: CGPoint) {
        self.position = position
    }
    
    internal func path(in rect: CGRect) -> Path {
        var combinedPaths = Path()
        var horizontalPath = Path()
        var verticalPath = Path()
        
        horizontalPath.move(to: CGPoint(x: 0, y: position.y))
        horizontalPath.addLine(to: CGPoint(x: rect.width, y: position.y))
        verticalPath.move(to: CGPoint(x: position.x, y: 0))
        verticalPath.addLine(to: CGPoint(x: position.x, y: rect.height))
        
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        return combinedPaths
    }
}

/// From bottom and leading edges meeting at a specified point.
internal struct MarkerBottomLeading: Shape {
    
    private let position: CGPoint
    private let lineWidth: CGFloat
    
    internal init(
        position: CGPoint,
        lineWidth: CGFloat
    ) {
        self.position = position
        self.lineWidth = lineWidth
    }
    
    internal func path(in rect: CGRect) -> Path {
        var combinedPaths = Path()
        var horizontalPath = Path()
        var verticalPath = Path()
        
        horizontalPath.move(to: CGPoint(x: 0, y: position.y))
        horizontalPath.addLine(to: CGPoint(x: position.x + lineWidth, y: position.y))
        verticalPath.move(to: CGPoint(x: position.x, y: rect.height))
        verticalPath.addLine(to: CGPoint(x: position.x, y: position.y + lineWidth))
        
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        return combinedPaths
    }
}

/// From bottom and trailing edges meeting at a specified point.
internal struct MarkerBottomTrailing: Shape {
    
    private let position: CGPoint
    private let lineWidth: CGFloat
    
    internal init(
        position: CGPoint,
        lineWidth: CGFloat
    ) {
        self.position = position
        self.lineWidth = lineWidth
    }
    
    internal func path(in rect: CGRect) -> Path {
        var combinedPaths = Path()
        var horizontalPath = Path()
        var verticalPath = Path()
        
        horizontalPath.move(to: CGPoint(x: rect.width, y: position.y))
        horizontalPath.addLine(to: CGPoint(x: position.x - (lineWidth / 2), y: position.y))
        verticalPath.move(to: CGPoint(x: position.x, y: rect.height))
        verticalPath.addLine(to: CGPoint(x: position.x, y: position.y - (lineWidth / 2)))
        
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        return combinedPaths
    }
}

// From top and leading edges meeting at a specified point.
internal struct MarkerTopLeading: Shape {
    
    private let position: CGPoint
    private let lineWidth: CGFloat
    
    internal init(
        position: CGPoint,
        lineWidth: CGFloat
    ) {
        self.position = position
        self.lineWidth = lineWidth
    }
    
    internal func path(in rect: CGRect) -> Path {
        var combinedPaths = Path()
        var horizontalPath = Path()
        var verticalPath = Path()
        
        horizontalPath.move(to: CGPoint(x: 0, y: position.y))
        horizontalPath.addLine(to: CGPoint(x: position.x + (lineWidth / 2), y: position.y))
        verticalPath.move(to: CGPoint(x: position.x, y: 0))
        verticalPath.addLine(to: CGPoint(x: position.x, y: position.y + (lineWidth / 2)))
        
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        return combinedPaths
    }
}

// From top and trailing edges meeting at a specified point.
internal struct MarkerTopTrailing: Shape {
    
    private let position: CGPoint
    private let lineWidth: CGFloat
    
    internal init(
        position: CGPoint,
        lineWidth: CGFloat
    ) {
        self.position = position
        self.lineWidth = lineWidth
    }
    
    internal func path(in rect: CGRect) -> Path {
        var combinedPaths = Path()
        var horizontalPath = Path()
        var verticalPath = Path()
        
        horizontalPath.move(to: CGPoint(x: rect.width, y: position.y))
        horizontalPath.addLine(to: CGPoint(x: position.x - (lineWidth / 2), y: position.y))
        verticalPath.move(to: CGPoint(x: position.x, y: 0))
        verticalPath.addLine(to: CGPoint(x: position.x, y: position.y + (lineWidth / 2)))
        
        combinedPaths.addPath(horizontalPath)
        combinedPaths.addPath(verticalPath)
        return combinedPaths
    }
}
