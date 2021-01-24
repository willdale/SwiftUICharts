//
//  LineChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/// Data model for a data point.
public struct LineChartDataPoint: ChartDataPoint {
    
    public let id = UUID()

    /// Value of the data point
    public var value            : Double
    /// Label that can be shown on the X axis.
    public var xAxisLabel       : String?
    /// A longer label that can be shown on touch input.
    public var pointDescription : String?
    /// Date of the data point if any data based calculations are asked for.
    public var date             : Date?
    
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
    }
}
