//
//  MultiPieDataPoint.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

/**
 Data for a single segement of a pie chart.
 
 # Example
 ```
 MultiPieDataPoint(value: 40, pointDescription: "One", colour: Color.red,
                   layerDataPoints: [
                     MultiPieDataPoint(value: 5, colour: Color.blue)
                   ])
 
 ```
 */
public struct MultiPieDataPoint: CTMultiPieChartDataPoint {
    
    public var id           : UUID = UUID()
    // CTPieDataPoint
    public var startAngle   : Double = 0
    public var amount       : Double = 0
    // CTChartDataPoint
    public var value            : Double
    public var pointDescription : String?
    public var date             : Date?
    // CTMultiPieChartDataPoint
    public var layerDataPoints  : [MultiPieDataPoint]?
    
    public var colour           : Color
    
    /// Data model for a single data point for a pie chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour of the segment.
    ///   - layerDataPoints: Optional data points for next layer out.
    public init(value           : Double,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red,
                layerDataPoints : [MultiPieDataPoint]? = nil
    ) {
        self.value              = value
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
        self.layerDataPoints    = layerDataPoints
    }
}
