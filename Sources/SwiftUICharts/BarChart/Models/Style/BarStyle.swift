//
//  BarStyle.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

/**
 Model for controlling the  aesthetic of the line chart.
 
 # Example
 ```
 BarStyle(barWidth      : 0.5,
          cornerRadius  : CornerRadius(top: 15),
          colourFrom    : .barStyle,
          colour        : .blue)
 ```
 
 ---
 
 # Options
 ```
 BarStyle(barWidth     : CGFloat,
          cornerRadius : CornerRadius,
          colourFrom   : ColourFrom,
          ...)
 
 BarStyle(...
          colour: Color)
 
 BarStyle(...
          colours: [Color],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 
 BarStyle(...
          stops: [GradientStop],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 ```
 
 ---
 
 # Also See
 - [ColourType](x-source-tag://ColourType)
 - [CornerRadius](x-source-tag://CornerRadius)
 - [ColourFrom](x-source-tag://ColourFrom)
 - [GradientStop](x-source-tag://GradientStop)
 
 # Conforms to
 - CTColourStyle
 - Hashable
 
 - Tag: BarStyle
 */
public struct BarStyle: CTColourStyle, Hashable {
   
    /// How much of the available width to use. 0...1
    var barWidth    : CGFloat
    /// Corner radius of the bar shape.
    var cornerRadius: CornerRadius
    /// Where to get the colour data from.
    var colourFrom  : ColourFrom

    public var colourType   : ColourType
    public var colour       : Color?
    public var colours      : [Color]?
    public var stops        : [GradientStop]?
    public var startPoint   : UnitPoint?
    public var endPoint     : UnitPoint?
    
    
    /// Bar Chart with single colour
    /// - Parameters:
    ///   - barWidth: How much of the available width to use. 0...1
    ///   - cornerRadius: Corner radius of the bar shape.
    ///   - colourFrom: Where to get the colour data from.
    ///   - colour: Single Colour
    public init(barWidth    : CGFloat       = 1,
                cornerRadius: CornerRadius  = CornerRadius(top: 5.0, bottom: 0.0),
                colourFrom  : ColourFrom    = .barStyle,
                colour      : Color?        = Color(.red)
    ) {
        self.barWidth       = barWidth
        self.cornerRadius   = cornerRadius
        self.colourFrom     = colourFrom
        self.colour         = colour
        self.colours        = nil
        self.stops          = nil
        self.startPoint     = nil
        self.endPoint       = nil
        self.colourType     = .colour
    }
    
    /// Bar Chart with Gradient Colour
    /// - Parameters:
    ///   - barWidth: How much of the available width to use. 0...1
    ///   - cornerRadius: Corner radius of the bar shape.
    ///   - colourFrom: Where to get the colour data from.
    ///   - colours: Colours for Gradient.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(barWidth    : CGFloat       = 1,
                cornerRadius: CornerRadius  = CornerRadius(top: 5.0, bottom: 0.0),
                colourFrom  : ColourFrom    = .barStyle,
                colours     : [Color]       = [Color(.red), Color(.blue)],
                startPoint  : UnitPoint     = .leading,
                endPoint    : UnitPoint     = .trailing
    ) {
        self.barWidth       = barWidth
        self.cornerRadius   = cornerRadius
        self.colourFrom     = colourFrom
        self.colour         = nil
        self.colours        = colours
        self.stops          = nil
        self.startPoint     = startPoint
        self.endPoint       = endPoint
        self.colourType     = .gradientColour
    }
    
    /// Bar Chart with Gradient with Stops
    /// - Parameters:
    ///   - barWidth: How much of the available width to use. 0...1
    ///   - cornerRadius: Corner radius of the bar shape.
    ///   - colourFrom: Where to get the colour data from.
    ///   - stops: Colours and Stops for Gradient with stop control.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(barWidth    : CGFloat = 1,
                cornerRadius: CornerRadius      = CornerRadius(top: 5.0, bottom: 0.0),
                colourFrom  : ColourFrom        = .barStyle,
                stops       : [GradientStop]    = [GradientStop(color: Color(.red), location: 0.0)],
                startPoint  : UnitPoint         =  .leading,
                endPoint    : UnitPoint         =  .trailing
    ) {
        self.barWidth       = barWidth
        self.cornerRadius   = cornerRadius
        self.colourFrom     = colourFrom
        self.colour         = nil
        self.colours        = nil
        self.stops          = stops
        self.startPoint     = startPoint
        self.endPoint       = endPoint
        self.colourType     = .gradientStops
    }
}
