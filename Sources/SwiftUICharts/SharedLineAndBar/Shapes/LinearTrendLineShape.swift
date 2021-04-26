//
//  LinearTrendLineShape.swift
//  
//
//  Created by Will Dale on 26/03/2021.
//

import SwiftUI

/**
 A line across the chart to show the trend in the data.
 */
internal struct LinearTrendLineShape: Shape {
    
    private let firstValue: Double
    private let lastValue: Double
    private let range: Double
    private let minValue: Double
    
    internal init(
        firstValue: Double,
        lastValue: Double,
        range: Double,
        minValue: Double
    ) {
        self.firstValue = firstValue
        self.lastValue = lastValue
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        path.move(to: CGPoint(x: 0,
                              y: (CGFloat(firstValue - minValue) * -y) + rect.height))
        path.addLine(to: CGPoint(x: rect.width,
                                 y: (CGFloat(lastValue - minValue) * -y) + rect.height))
        return path
    }
}
