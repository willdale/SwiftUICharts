//
//  ChartDataPoints.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/// Data model for a data point.
public struct ChartDataPoint: Hashable, Identifiable {
    
    public let id = UUID()

    /// Value of the data point
    public var value            : Double
    /// Label that can be shown on the X axis.
    public var xAxisLabel       : String?
    /// A longer label that can be shown on touch input.
    public var pointDescription : String?
    /// Date of the data point if any data based calculations are asked for.
    public var date             : Date?
    
    /// Type of colour styling for the chart.
    public var colourType   : ColourType
    /// Single Colour
    public var colour  : Color?
    /// Colours for Gradient
    public var colours : [Color]?
    /// Colours and Stops for Gradient with stop control
    public var stops   : [GradientStop]?
    
    /// Start point for Gradient
    public var startPoint  : UnitPoint?
    /// End point for Gradient
    public var endPoint    : UnitPoint?
    
    // MARK: - init: single colour
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
    
    // MARK: - init: gradient colour
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
    
    // MARK: - init: gradient with stops
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
