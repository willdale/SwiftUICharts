//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Generic line, drawn horizontally across the chart
internal struct Marker: Shape {
    
    private let value: Double
    private let chartType: ChartType
    private let range: Double
    private let minValue: Double
    
    internal init(
        value: Double,
        range: Double,
        minValue: Double,
        chartType: ChartType
    ) {
        self.value = value
        self.range = range
        self.minValue = minValue
        self.chartType = chartType
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointY: CGFloat = getYPointLocation(rect: rect, chartType: chartType, value: value, minValue: minValue, range: range)
        let firstPoint = CGPoint(x: 0, y: pointY)
        let nextPoint = CGPoint(x: rect.width, y: pointY)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
    
    private func getYPointLocation(
        rect: CGRect,
        chartType: ChartType,
        value: Double,
        minValue: Double,
        range: Double
    ) -> CGFloat {
        switch chartType {
        case .line:
            let y = rect.height / CGFloat(range)
            return (CGFloat(value - minValue) * -y) + rect.height
        case .bar:
            let y = CGFloat(value - minValue)
            return (rect.height - (y / CGFloat(range)) * rect.height)
        case .pie:
            return 0
        }
    }
}
