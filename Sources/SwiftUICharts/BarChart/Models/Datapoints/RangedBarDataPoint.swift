//
//  RangedBarDataPoint.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

public struct RangedBarDataPoint : CTRangedBarDataPoint {

    public let id = UUID()

    public var upperValue       : Double
    public var lowerValue       : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    public var fillColour       : ColourStyle
    

    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - lowerValue: Value of the lower range of the data point.
    ///   - upperValue: Value of the upper range of the data point.
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - fillColour: Colour styling for the fill.
    public init(lowerValue  : Double,
                upperValue  : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                fillColour  : ColourStyle = ColourStyle(colour: .red)
    ) {
        self.upperValue       = upperValue
        self.lowerValue       = lowerValue
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        self.fillColour       = fillColour
    }
    
    public typealias ID = UUID
}
