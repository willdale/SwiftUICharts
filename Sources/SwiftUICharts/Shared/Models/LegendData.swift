//
//  LegendData.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/**
 Data model to hold data for Legends
 */
 public struct LegendData: CTColourStyle, Hashable, Identifiable {
    
    // MARK: - Parameters
    
    public var id           : UUID
    /// The type of chart being used.
    public var chartType    : ChartType
    /// Text to be displayed
    public var legend       : String
    /// Style of the stroke
    public var strokeStyle  : Stroke?
    
    /// Used to make sure the charts data legend is first
    public let prioity      : Int
    
    public var colourType   : ColourType
    public var colour       : Color?
    public var colours      : [Color]?
    public var stops        : [GradientStop]?
    public var startPoint   : UnitPoint?
    public var endPoint     : UnitPoint?
    
    // MARK: - Single Color
    /// Legend with single colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colour: Single Colour
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    ///   - chartType: Type of chart being used.
    public init(id         : UUID,
                legend     : String,
                colour     : Color,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.id          = id
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
    
    // MARK: - Gradient Color
    /// Legend with a gradient colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colours: Colours for Gradient
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    ///   - chartType: Type of chart being used.
    public init(id         : UUID,
                legend     : String,
                colours    : [Color],
                startPoint : UnitPoint,
                endPoint   : UnitPoint,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.id          = id
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
    
    // MARK: - Gradient Stops Color
    /// Legend with a gradient with stop control
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - stops: Colours and Stops for Gradient with stop control
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - strokeStyle: Stroke Style
    ///   - prioity: Used to make sure the charts data legend is first
    ///   - chartType: Type of chart being used.
    public init(id         : UUID,
                legend     : String,
                stops      : [GradientStop],
                startPoint : UnitPoint,
                endPoint   : UnitPoint,
                strokeStyle: Stroke?,
                prioity    : Int,
                chartType  : ChartType
    ) {
        self.id          = id
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
