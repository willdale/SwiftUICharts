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
    
    private let chartType   : ChartType
    
    internal init(chartData   : ChartData,
                  markerValue : Double = 0,
                  isAverage   : Bool,
                  chartType   : ChartType
    ) {
        self.chartData   = chartData
        self.markerValue = markerValue
        self.isAverage   = isAverage
        self.chartType   = chartType
    }
    
    internal func path(in rect: CGRect) -> Path {
        
        let range   : Double = chartData.range()
        let minValue: Double = chartData.minValue()
        let value   : Double = isAverage ? chartData.average() : markerValue
        
        var path  = Path()

        let pointY  : CGFloat
        switch chartType {
        case .line:
            let y = rect.height / CGFloat(range)
            pointY = (CGFloat(value - minValue) * -y) + rect.height
        case .bar:
            let y = rect.height / CGFloat(chartData.maxValue())
            pointY = rect.height - CGFloat(value) * y
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
