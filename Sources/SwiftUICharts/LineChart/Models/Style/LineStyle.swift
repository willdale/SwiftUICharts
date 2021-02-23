//
//  LineStyle.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/**
 Model for controlling the aesthetic of the line chart.
 
 # Example
 
 ```
 LineStyle(colour     : .red,
           lineType   : .curvedLine,
           strokeStyle: Stroke(lineWidth: 2))
 ```
 
 */
public struct LineStyle: CTColourStyle, Hashable {    
        
    public var colourType  : ColourType
    public var colour      : Color?
    public var colours     : [Color]?
    public var stops       : [GradientStop]?
    public var startPoint  : UnitPoint?
    public var endPoint    : UnitPoint?
    
    /// Drawing style of the line
    public var lineType    : LineType
    
    /**
     Styling for stroke
     
     Replica of Apple’s StrokeStyle that conforms to Hashable
     */
    public var strokeStyle : Stroke

    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
        
     The default is false.
    */
    public var ignoreZero  : Bool
        
    // MARK: - Single colour
    /// Single Colour
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(colour      : Color      = Color(.red),
                lineType    : LineType   = .curvedLine,
                strokeStyle : Stroke = Stroke(lineWidth : 3,
                                              lineCap   : .round,
                                              lineJoin  : .round,
                                              miterLimit: 10,
                                              dash      : [CGFloat](),
                                              dashPhase : 0),
                ignoreZero  : Bool       = false
    ) {
        self.colourType     = .colour
        self.lineType       = lineType
        self.strokeStyle    = strokeStyle

        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
                
        self.ignoreZero = ignoreZero
    }
    
    // MARK: - Gradient colour
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
                
                strokeStyle : Stroke     = Stroke(lineWidth: 3,
                                                        lineCap: .round,
                                                        lineJoin: .round,
                                                        miterLimit: 10,
                                                        dash: [CGFloat](),
                                                        dashPhase: 0),
                ignoreZero  : Bool       = false
    ) {
        self.colourType  = .gradientColour
        self.lineType   = lineType
        self.strokeStyle = strokeStyle
        
        self.colour     = nil
        self.stops      = nil
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
                
        self.ignoreZero = ignoreZero
    }
    
    // MARK: - Gradient with stops
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
                
                strokeStyle : Stroke = Stroke(lineWidth: 3,
                                              lineCap: .round,
                                              lineJoin: .round,
                                              miterLimit: 10,
                                              dash: [CGFloat](),
                                              dashPhase: 0),
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
        
        self.ignoreZero     = ignoreZero
    }
}


