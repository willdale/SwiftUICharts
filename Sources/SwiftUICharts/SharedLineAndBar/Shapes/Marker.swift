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
    
<<<<<<< HEAD:Sources/SwiftUICharts/Shared/Shapes/Marker.swift
    private let minValue : Double
    private let range    : Double
    
    internal init(chartData   : ChartData,
                  markerValue : Double = 0,
                  isAverage   : Bool,
                  chartType   : ChartType
    ) {
        self.chartData   = chartData
        self.markerValue = markerValue
        self.isAverage   = isAverage
        self.chartType   = chartType
        
        switch chartData.lineStyle.baseline {
        case .minimumValue:
            self.minValue = chartData.minValue()
            self.range    = chartData.range()
        case .minimumWithMaximum(of: let value):
            self.minValue = min(chartData.minValue(), value)
            self.range    = chartData.maxValue() - min(chartData.minValue(), value)
        case .zero:
            self.minValue = 0
            self.range    = chartData.maxValue()
        }
    }
    
    internal func path(in rect: CGRect) -> Path {
        
        let value   : Double = isAverage ? chartData.average() : markerValue
        
=======
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

>>>>>>> version-2:Sources/SwiftUICharts/SharedLineAndBar/Shapes/Marker.swift
        var path  = Path()

        let pointY  : CGFloat
        switch chartType {
        case .line:
            let y = rect.height / CGFloat(range)
            pointY = (CGFloat(value - minValue) * -y) + rect.height
        case .bar:
            let y = CGFloat(value - minValue)
            pointY = (rect.height - (y / CGFloat(range)) * rect.height)
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
