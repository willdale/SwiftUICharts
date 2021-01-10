//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Generic line drawn horrizontally across the chart
internal struct Marker: Shape { 
    
    private let chartData   : ChartData
    private let markerValue : Double
    private let isAverage   : Bool
    
    internal init(chartData   : ChartData,
                  markerValue : Double = 0,
                  isAverage   : Bool
    ) {
        self.chartData  = chartData
        self.markerValue = markerValue
        self.isAverage = isAverage
    }
    
    internal func path(in rect: CGRect) -> Path {
        
        let range   : Double = chartData.range()
        let minValue: Double = chartData.minValue()
        let value   : Double = isAverage ? chartData.average() : markerValue
        
        var path  = Path()
        
        let y = rect.height / CGFloat(range)
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(value - minValue) * -y) + rect.height)
        let nextPoint = CGPoint(x: rect.width,
                                y: (CGFloat(value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        
        return path
    }
    
}
