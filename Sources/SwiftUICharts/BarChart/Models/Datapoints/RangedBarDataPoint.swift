//
//  RangedBarDataPoint.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 Data for a single ranged bar chart data point.
 */
public struct RangedBarDataPoint: CTRangedBarDataPoint {
    
    public let id: UUID = UUID()
    public var upperValue: Double
    public var lowerValue: Double
    public var xAxisLabel: String?
    public var description: String?
    public var date: Date?
    public var colour: ColourStyle
    public var legendTag: String = ""
    
    internal var _value: Double = 0
    internal var _valueOnly: Bool = false
    
    /// Data model for a single data point with colour for use with a ranged bar chart.
    /// - Parameters:
    ///   - lowerValue: Value of the lower range of the data point.
    ///   - upperValue: Value of the upper range of the data point.
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour styling for the fill.
    public init(
        lowerValue: Double,
        upperValue: Double,
        xAxisLabel: String? = nil,
        description: String? = nil,
        date: Date? = nil,
        colour: ColourStyle = ColourStyle(colour: .red)
    ) {
        self.upperValue = upperValue
        self.lowerValue = lowerValue
        self.xAxisLabel = xAxisLabel
        self.description = description
        self.date = date
        self.colour = colour
    }
    
    public typealias ID = UUID
}
