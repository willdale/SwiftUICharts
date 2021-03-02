//
//  LineChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for a single data point.
 
 # Example
 ```
 LineChartDataPoint(value      : 20,
                    xAxisLabel : "M",
                    pointLabel : "Monday",
                    date       : Date())
 ```
 */
public struct LineChartDataPoint: CTLineDataPointProtocol {
    
    public let id               : UUID = UUID()

    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    
    var testlabel : String
    
    /// Data model for a single data point with colour for use with a line chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                
                testlabel : String = ""
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        
        self.testlabel = testlabel
    }
}
