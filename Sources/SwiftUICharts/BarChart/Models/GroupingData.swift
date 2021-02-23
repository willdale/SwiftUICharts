//
//  GroupingData.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

/**
 Model for grouping data points together so they can be drawn in the correct groupings.
 
 # Example
 ```
 GroupingData(title: "One", colour: .blue)
 ```
 */
public struct GroupingData: CTColourStyle, Hashable, Identifiable {
    
    public let id        : UUID = UUID()
    public var title     : String
    public var colourType: ColourType
    public var colour    : Color?
    public var colours   : [Color]?
    public var stops     : [GradientStop]?
    public var startPoint: UnitPoint?
    public var endPoint  : UnitPoint?
     
    // MARK: - Single colour
    /// Group with single colour
    /// - Parameters:
    ///   - title: Title for legends
    ///   - colour: Colour drawing the bars and legends
    public init(title   : String,
                colour  : Color
    ) {
        self.title      = title
        self.colourType = .colour
        self.colour     = colour
        self.colours    = nil
        self.stops      = nil
        self.startPoint = nil
        self.endPoint   = nil
    }
    
    // MARK: - Gradient colour
    /// Group with gradient colours.
    /// - Parameters:
    ///   - title: Title for legends
    ///   - colours: Colours drawing the bars and legends
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(title       : String,
                colours     : [Color],
                startPoint  : UnitPoint,
                endPoint    : UnitPoint
    ) {
        self.title      = title
        self.colourType = .gradientColour
        self.colour     = nil
        self.colours    = colours
        self.stops      = nil
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
    
    // MARK: - Gradient with stops
    /// Group with gradient colours and stops control.
    /// - Parameters:
    ///   - title: Title for legends
    ///   - stops: Colours drawing the bars and legends
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(title       : String,
                stops       : [GradientStop],
                startPoint  : UnitPoint,
                endPoint    : UnitPoint
    ) {
        self.title      = title
        self.colourType = .gradientStops
        self.colour     = nil
        self.colours    = nil
        self.stops      = stops
        self.startPoint = startPoint
        self.endPoint   = endPoint
    }
}
