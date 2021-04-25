//
//  PieSegmentShape.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Draws a pie segment.
 */
internal struct PieSegmentShape: Shape, Identifiable {
    
    var id: UUID
    var startAngle: Double
    var amount: Double
    
    internal func path(in rect: CGRect) -> Path {
        let radius = min(rect.width, rect.height) / 2
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        var path = Path()
        path.move(to: center)
        path.addRelativeArc(center: center,
                            radius: radius,
                            startAngle: Angle(radians: startAngle),
                            delta: Angle(radians: amount))
        return path
    }
}
