//
//  BarStyle.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

/// Model for controlling the aesthetic of the bar chart.
public struct BarStyle: Style, Hashable {
   
    /// How much of the available width to use. 0 ..1
    var barWidth    : CGFloat
    /// Corner radius of the bar shape.
    var cornerRadius: CornerRadius
    /// Where to get the colour data from.
    var colourFrom  : ColourFrom
    /// Type of colour styling for the chart.
    public var colourType  : ColourType
    
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
    
//    public var ignoreZero: Bool
    
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

/// Corner radius of the bar shape.
public struct CornerRadius: Hashable {
    
    var top     : CGFloat
    var bottom  : CGFloat
    
    public init(top: CGFloat, bottom: CGFloat) {
        self.top = top
        self.bottom = bottom
    }
}


