//
//  ChartDataPoints.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/// Data model for a data point.
public struct ChartDataPoint: Hashable {
    /// Value of the data point
    let value            : Double
    /// Label that can be shown on the X axis.
    let xAxisLabel       : String?
    /// A longer label that can be shown on touch input.
    let pointDescription : String?
    /// Date of the data point if any data based calculations are asked for.
    let date             : Date?
    
    /// Data model for a data point.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are asked for.
    public init(value: Double, xAxisLabel: String? = nil, pointLabel: String? = nil, date: Date? = nil) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
    }
}
