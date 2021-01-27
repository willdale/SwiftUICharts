//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Generic line drawn horrizontally across the chart
internal struct Marker: Shape {
    
    private let value : Double
    private let chartType   : ChartType
    
    let range   : Double
    let minValue: Double
    let maxValue: Double
    
    internal init(value       : Double,
                  range       : Double,
                  minValue    : Double,
                  maxValue    : Double,
                  chartType   : ChartType
    ) {
        self.value      = value
        self.range      = range
        self.minValue   = minValue
        self.maxValue   = maxValue
        self.chartType  = chartType
    }
    
    internal func path(in rect: CGRect) -> Path {

        var path  = Path()

        let pointY  : CGFloat
        switch chartType {
        case .line:
            let y = rect.height / CGFloat(range)
            pointY = (CGFloat(value - minValue) * -y) + rect.height
        case .bar:
            let y = rect.height / CGFloat(maxValue)
            pointY = rect.height - CGFloat(value) * y
        case .pie:
            pointY = 0
        }
        
        let firstPoint = CGPoint(x: 0,
                                 y: pointY)
 
        let nextPoint = CGPoint(x: rect.width,
                                y: pointY)
        
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        
        return path
    }
    
}
