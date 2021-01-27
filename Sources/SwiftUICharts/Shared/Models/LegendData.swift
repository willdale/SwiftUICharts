//
//  LegendData.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/// Data model for Legends
public struct LegendData: CTColourStyle, Hashable {
    
    var chartType           : ChartType
    public var colourType   : ColourType
    /// Text to be displayed
    var legend      : String
    
    /// Style of the stroke
    var strokeStyle : Stroke?
    
    /// Single Colour
    public var colour      : Color?
    /// Colours for Gradient
    public var colours     : [Color]?
    /// Colours and Stops for Gradient with stop control
    public var stops       : [GradientStop]?
    
    /// Start point for Gradient
    public var startPoint  : UnitPoint?
    /// End point for Gradient
    public var endPoint    : UnitPoint?
    
    /// Used to make sure the charts data legend is first
    let prioity     : Int
    
    /// Legend with single colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colour: Single Colour
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    public init(legend     : String,
                colour     : Color,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.legend      = legend
        self.colour      = colour
        self.colours     = nil
        self.stops       = nil
        self.startPoint  = nil
        self.endPoint    = nil
        self.strokeStyle = strokeStyle
        self.prioity     = prioity
        self.chartType   = chartType
        self.colourType  = .colour
    }
    
    /// Legend with a gradient colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colours: Colours for Gradient
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    public init(legend     : String,
                colours    : [Color],
                startPoint : UnitPoint,
                endPoint   : UnitPoint,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.legend      = legend
        self.colour      = nil
        self.colours     = colours
        self.stops       = nil
        self.startPoint  = startPoint
        self.endPoint    = endPoint
        self.strokeStyle = strokeStyle
        self.prioity     = prioity
        self.chartType   = chartType
        self.colourType  = .gradientColour
    }
    
    /// Legend with a gradient with stop control
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - stops: Colours and Stops for Gradient with stop control
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    public init(legend     : String,
                stops      : [GradientStop],
                startPoint : UnitPoint,
                endPoint   : UnitPoint,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.legend      = legend
        self.colour      = nil
        self.colours     = nil
        self.stops       = stops
        self.startPoint  = startPoint
        self.endPoint    = endPoint
        self.strokeStyle = strokeStyle
        self.prioity     = prioity
        self.chartType   = chartType
        self.colourType  = .gradientStops
    }
}
