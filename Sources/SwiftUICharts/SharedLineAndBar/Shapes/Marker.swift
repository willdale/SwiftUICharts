//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

internal struct AxisHorizontalMarker: Shape {
    
    internal let yPosition: CGFloat

    internal func path(in rect: CGRect) -> Path {
        let firstPoint = CGPoint(x: 0, y: yPosition)
        let nextPoint = CGPoint(x: rect.width, y: yPosition)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

internal struct AxisVerticalMarker: Shape {
    
    internal let yPosition: CGFloat

    internal func path(in rect: CGRect) -> Path {
        let firstPoint = CGPoint(x: yPosition, y: 0)
        let nextPoint = CGPoint(x: yPosition, y: rect.height)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}
