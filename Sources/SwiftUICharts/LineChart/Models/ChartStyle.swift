//
//  ChartStyle.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/// Model for controlling the overall aesthetic of the chart.
public struct ChartStyle {
    
    /// Type of colour styling for the chart.
    let styleType   : StyleType
    /// Drawing style of the line
    let lineType    : LineType
    let lineWidth   : CGFloat
    let lineCap     : CGLineCap
    let lineJoin    : CGLineJoin
    let miterLimit  : CGFloat
    
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

    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
        
     The default is false.
     */
    let ignoreZero  : Bool
        
    /// Single Colour
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(colour      : Color      = Color(.systemRed),
                lineType    : LineType   = .curvedLine,
                lineWidth   : CGFloat    = 3,
                lineCap     : CGLineCap  = .round,
                lineJoin    : CGLineJoin = .round,
                miterLimit  : CGFloat    = 10,
                ignoreZero  : Bool       = false
    ) {
        self.styleType  = .colour
        self.lineType   = lineType
       
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit

        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
                
        self.ignoreZero = ignoreZero
    }
    
    /// Gradient Colour Line
    /// - Parameters:
    ///   - colours: Colours for Gradient
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - lineType: Drawing style of the line
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(colours     : [Color]?   =  [.red, .blue],
                startPoint  : UnitPoint? =  .leading,
                endPoint    : UnitPoint? =  .trailing,
                lineType    : LineType   = .curvedLine,
                lineWidth   : CGFloat    = 3,
                lineCap     : CGLineCap  = .round,
                lineJoin    : CGLineJoin = .round,
                miterLimit  : CGFloat    = 10,
                ignoreZero  : Bool       = false
    ) {
        self.styleType  = .gradientColour
        self.lineType   = lineType
        
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap   
        self.lineJoin   = lineJoin  
        self.miterLimit = miterLimit
        
        self.colour     = nil
        self.stops      = nil
        self.colours    = colours
        self.startPoint = startPoint
        self.endPoint   = endPoint
                
        self.ignoreZero = ignoreZero
    }
    
    /// Gradient with Stops Line
    /// - Parameters:
    ///   - stops: Colours and Stops for Gradient with stop control
    ///   - startPoint: Start point for Gradient
    ///   - endPoint: End point for Gradient
    ///   - lineType: Drawing style of the line
    ///   - lineWidth: Line Width
    ///   - lineCap: Line Cap
    ///   - lineJoin: Line Join
    ///   - miterLimit: Miter Limit
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(stops       : [GradientStop] = [GradientStop(color: .red, location: 0.0)],
                startPoint  : UnitPoint? =  .leading,
                endPoint    : UnitPoint? =  .trailing,
                lineType    : LineType   = .curvedLine,
                lineWidth   : CGFloat    = 3,
                lineCap     : CGLineCap  = .round,
                lineJoin    : CGLineJoin = .round,
                miterLimit  : CGFloat    = 10,
                ignoreZero  : Bool       = false
    ) {
        self.styleType  = .gradientStops
        self.lineType   = lineType
        
        self.lineWidth  = lineWidth
        self.lineCap    = lineCap
        self.lineJoin   = lineJoin
        self.miterLimit = miterLimit
        
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
                
        self.ignoreZero = ignoreZero
    }
    /**
     Type of colour styling for the chart.
     ```
     case colour // Single Colour
     case gradientColour // Colour Gradient
     case gradientStops // Colour Gradient with stop control
     ```
     */
    enum StyleType {
        /// Single Colour
        case colour
        /// Colour Gradient
        case gradientColour
        /// Colour Gradient with stop control
        case gradientStops
    }
}

