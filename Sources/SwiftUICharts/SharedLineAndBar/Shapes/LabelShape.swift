//
//  LabelShape.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import SwiftUI

/**
 Shape used in POI Markers when displaying value in the Y axid labels.
 */
public struct LabelShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX - (rect.width / 5), y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX - (rect.width / 5), y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.closeSubpath()
        return path
    }
}
