//
//  VerticalGridShape.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

/**
 Basic Vertical line shape.
 
 Used in Grid
 */
internal struct VerticalGridShape: Shape {
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        return path
    }
}
