//
//  DiamondShape.swift
//
//
//  Created by Will Dale on 07/02/2021.
//

import SwiftUI

public struct DiamondShape: Shape {
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
                  
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        
        path.closeSubpath()
        
        return path
    }
    
}
