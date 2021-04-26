//
//  RangedLineStyle.swift
//  
//
//  Created by Will Dale on 02/03/2021.
//

import SwiftUI
/**
 Model for controlling the aesthetic of the ranged line chart.
 */
public struct RangedLineStyle: CTRangedLineStyle, Hashable {
    
    public var lineColour: ColourStyle
    public var fillColour: ColourStyle
    public var lineType: LineType
    public var strokeStyle: Stroke
    public var ignoreZero: Bool
    
    // MARK: Initializer
    /// Initialize the styling for ranged line chart.
    ///
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(lineColour: ColourStyle = ColourStyle(),
                fillColour: ColourStyle = ColourStyle(),
                lineType: LineType = .curvedLine,
                strokeStyle: Stroke = Stroke(),
                ignoreZero: Bool = false
    ) {
        self.lineColour  = lineColour
        self.fillColour  = fillColour
        self.lineType    = lineType
        self.strokeStyle = strokeStyle
        self.ignoreZero  = ignoreZero
    }
}
