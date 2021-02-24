//
//  PieChartDataPoint.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 Data for a single segement of a pie chart.
 
 # Example
 ```
 PieChartDataPoint(value: 7,
                   pointDescription: "One",
                   colour: .blue),
 ```
 */
public struct PieChartDataPoint: CTPieDataPoint {
    
    public var id               : UUID = UUID()
    public var value            : Double
    public var pointDescription : String?
    public var date             : Date?
    
    public var colour           : Color
    
    public var startAngle  : Double = 0
    public var amount      : Double = 0
    
    /// Data model for a single data point for a pie chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour of the segment.
    public init(value           : Double,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red
    ) {
        self.value              = value
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
    }
}