//
//  LegendLine.swift
//  LineChart
//
//  Created by Will Dale on 05/01/2021.
//

import SwiftUI

internal struct LegendLine: Shape {
    
    private let width: CGFloat
    
    internal init(width: CGFloat) {
        self.width = width
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height / 2))
        path.addLine(to: CGPoint(x: width, y: rect.height / 2))
        return path
    }
}
