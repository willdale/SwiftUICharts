//
//  LineStyle.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI
 
/// Model for controlling the  aesthetic of the line chart.
public struct LineStyle {

    /// Type of colour styling for the chart.
    public var colourType   : ColourType
    /// Drawing style of the line
    public var lineType    : LineType
    
    public var baseline    : Baseline
    
    public var strokeStyle : StrokeStyle
     
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

    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
        
     The default is false.
    */
    public var ignoreZero  : Bool
        
    /// Single Colour
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(colour       : Color       = Color(.red),
                lineType     : LineType    = .curvedLine,
                strokeStyle  : StrokeStyle = StrokeStyle(lineWidth: 3,
                                                         lineCap: .round,
                                                         lineJoin: .round,
                                                         miterLimit: 10,
                                                         dash: [CGFloat](),
                                                         dashPhase: 0),
                baseline     : Baseline   = .minimumValue,
                ignoreZero   : Bool       = false
    ) {
        self.colourType     = .colour
        self.lineType       = lineType
        self.strokeStyle    = strokeStyle

        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
                
        self.baseline  = baseline
        self.ignoreZero = ignoreZero
    }
    
    /// Gradient Colour Line
    /// - Parameters:
    ///   - colours: Colours for Gradient.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    ///   - lineType: Drawing style of the line.
    ///   - strokeStyle: Stroke Style.
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(colours     : [Color]    =  [Color(.red), Color(.blue)],
                startPoint  : UnitPoint  =  .leading,
                endPoint    : UnitPoint  =  .trailing,
                lineType    : LineType   = .curvedLine,
                strokeStyle : StrokeStyle = StrokeStyle(lineWidth: 3,
                                                        lineCap: .round,
                                                        lineJoin: .round,
                                                        miterLimit: 10,
                                                        dash: [CGFloat](),
                                                        dashPhase: 0),
                baseline    : Baseline   = .minimumValue,
                ignoreZero  : Bool       = false
    ) {
        self.colourType  = .gradientColour
        self.lineType   = lineType
        self.strokeStyle    = strokeStyle
        
        self.colour     = nil
        self.stops      = nil
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
                
        self.baseline  = baseline
        self.ignoreZero = ignoreZero
    }
    
    /// Gradient with Stops Line
    /// - Parameters:
    ///   - stops: Colours and Stops for Gradient with stop control.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    ///   - lineType: Drawing style of the line.
    ///   - strokeStyle: Stroke Style.
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(stops       : [GradientStop]    = [GradientStop(color: Color(.red), location: 0.0)],
                startPoint  : UnitPoint         =  .leading,
                endPoint    : UnitPoint         =  .trailing,
                lineType    : LineType          = .curvedLine,
                strokeStyle : StrokeStyle = StrokeStyle(lineWidth: 3,
                                                        lineCap: .round,
                                                        lineJoin: .round,
                                                        miterLimit: 10,
                                                        dash: [CGFloat](),
                                                        dashPhase: 0),
                baseline    : Baseline   = .minimumValue,
                ignoreZero  : Bool       = false
    ) {
        self.colourType     = .gradientStops
        self.lineType       = lineType
        
        self.strokeStyle    = strokeStyle
        self.colour         = nil
        self.colours        = nil
        self.stops          = stops
        self.startPoint     = startPoint
        self.endPoint       = endPoint
        self.baseline  = baseline
                
        self.ignoreZero     = ignoreZero
    }
    
    public enum Baseline {
        case minimumValue
        case minimumWithMaximum(of: Double)
        case zero
    }
}


