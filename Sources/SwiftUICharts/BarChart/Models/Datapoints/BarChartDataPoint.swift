//
//  BarChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for a single bar chart data point.
 
 Colour can be solid or gradient.
 
 # Example
 ```
 BarChartDataPoint(value: 90,
                   xAxisLabel: "T",
                   pointLabel: "Tuesday",
                   colour: .blue)
 ```
 */
public struct BarChartDataPoint: CTStandardBarDataPoint {
    
    public let id = UUID()

    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    
    public var colourType   : ColourType
    public var colour       : Color?
    public var colours      : [Color]?
    public var stops        : [GradientStop]?
    public var startPoint   : UnitPoint?
    public var endPoint     : UnitPoint?
    
    // MARK: - Single colour
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour for use with a bar chart.
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                colour      : Color?    = nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
        self.colourType = .colour
    }
    
    // MARK: - Gradient colour
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colours: Array of colours for use with a bar chart.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint : End point for Gradient.
    public init(value       : Double,
                xAxisLabel  : String? = nil,
                pointLabel  : String? = nil,
                date        : Date? = nil,
                
                colours     : [Color]?   =  nil,
                startPoint  : UnitPoint? =  nil,
                endPoint    : UnitPoint? =  nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        
        self.colour     = nil
        self.stops      = nil
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.colourType  = .gradientColour
    }
    
    // MARK: - Gradient with stops
    /// Data model for a single data point with colour for use with a bar chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - pointLabel: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - stops: Array of GradientStop for use with a bar chart.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint : End point for Gradient.
    public init(value       : Double,
                xAxisLabel  : String? = nil,
                pointLabel  : String? = nil,
                date        : Date? = nil,
                stops       : [GradientStop]? = nil,
                startPoint  : UnitPoint? =  nil,
                endPoint    : UnitPoint? =  nil
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
        self.colourType  = .gradientStops
    }
}
