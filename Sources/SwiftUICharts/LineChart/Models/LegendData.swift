//
//  LegendData.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/// Data model for Legends
internal struct LegendData: Hashable {
    
    /// Text to be displayed
    let legend      : String

    /// Single Colour
    let colour      : Color?
    /// Colours for Gradient
    let colours     : [Color]?
    /// Colours and Stops for Gradient with stop control
    let stops       : [GradientStop]?
    
    /// Start point for Gradient
    let startPoint  : UnitPoint?
    /// End point for Gradient
    let endPoint    : UnitPoint?
    
    let lineWidth   : CGFloat
    let lineCap     : CGLineCap
    let lineJoin    : CGLineJoin
    let miterLimit  : CGFloat
    let dash        : [CGFloat]
    let dashPhase   : CGFloat
    
    /// Legend with single colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colour: Single Colour
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - dash: Dash
    ///   - dashPhase: Dash Phase
    internal init(legend     : String,
                  colour     : Color,
                  lineWidth  : CGFloat      = 3,
                  lineCap    : CGLineCap    = .round,
                  lineJoin   : CGLineJoin   = .round,
                  miterLimit : CGFloat      = 10,
                  dash       : [CGFloat]    = [CGFloat](),
                  dashPhase  : CGFloat      = 0
    ) {
        self.legend   = legend
        
        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        
        self.startPoint = nil
        self.endPoint   = nil
        
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        self.dash       = dash
        self.dashPhase  = dashPhase
        
    }
    
    /// Legend with a gradient colour
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - colours: Colours for Gradient
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - dash: Dash
    ///   - dashPhase: Dash Phase
    internal init(legend     : String,
                  colours    : [Color],
                  startPoint : UnitPoint,
                  endPoint   : UnitPoint,
                  
                  lineWidth  : CGFloat      = 3,
                  lineCap    : CGLineCap    = .round,
                  lineJoin   : CGLineJoin   = .round,
                  miterLimit : CGFloat      = 10,
                  dash       : [CGFloat]    = [CGFloat](),
                  dashPhase  : CGFloat      = 0
    ) {
        self.legend     = legend
        
        self.colour     = nil
        self.colours    = colours
        self.stops      = nil
        
        self.startPoint = startPoint
        self.endPoint   = endPoint
        
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        self.dash       = dash
        self.dashPhase  = dashPhase
    }
    
    /// Legend with a gradient with stop control
    /// - Parameters:
    ///   - legend: Text to be displayed
    ///   - stops: Colours and Stops for Gradient with stop control
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - dash: Dash
    ///   - dashPhase: Dash Phase
    internal init(legend     : String,
                  stops      : [GradientStop],
                  startPoint : UnitPoint,
                  endPoint   : UnitPoint,
                  
                  lineWidth  : CGFloat      = 3,
                  lineCap    : CGLineCap    = .round,
                  lineJoin   : CGLineJoin   = .round,
                  miterLimit : CGFloat      = 10,
                  dash       : [CGFloat]    = [CGFloat](),
                  dashPhase  : CGFloat      = 0
    ) {
        self.legend     = legend
        
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        
        self.startPoint = startPoint
        self.endPoint   = endPoint
        
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        self.dash       = dash
        self.dashPhase  = dashPhase
    }
}

