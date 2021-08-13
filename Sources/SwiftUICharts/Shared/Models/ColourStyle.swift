//
//  ColourStyle.swift
//  
//
//  Created by Will Dale on 02/03/2021.
//

import SwiftUI

/**
 Model for setting up colour styling.
 */
public struct ColourStyle: CTColourStyle, Hashable {
    
    public var colourType: ColourType
    public var colour: Color?
    public var colours: [Color]?
    public var stops: [GradientStop]?
    public var startPoint: UnitPoint?
    public var endPoint: UnitPoint?
    
    // MARK: Single colour
    /// Single Colour
    /// - Parameters:
    ///   - colour: Single Colour
    public init(colour: Color = Color(.red)) {
        self.colourType = .colour
        self.colour = colour
        self.colours = nil
        self.stops = nil
        self.startPoint = nil
        self.endPoint = nil
    }
    
    // MARK: Gradient colour
    /// Gradient Colour Line
    /// - Parameters:
    ///   - colours: Colours for Gradient.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(
        colours: [Color] =  [Color(.red), Color(.blue)],
        startPoint: UnitPoint =  .leading,
        endPoint: UnitPoint =  .trailing
    ) {
        self.colourType = .gradientColour
        self.colour = nil
        self.colours = colours
        self.stops = nil
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    // MARK: Gradient with stops
    /// Gradient with Stops Line
    /// - Parameters:
    ///   - stops: Colours and Stops for Gradient with stop control.
    ///   - startPoint: Start point for Gradient.
    ///   - endPoint: End point for Gradient.
    public init(
        stops: [GradientStop] = [GradientStop(color: Color(.red), location: 0.0)],
        startPoint: UnitPoint = .leading,
        endPoint: UnitPoint = .trailing
    ) {
        self.colourType = .gradientStops
        self.colour = nil
        self.colours = nil
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}
