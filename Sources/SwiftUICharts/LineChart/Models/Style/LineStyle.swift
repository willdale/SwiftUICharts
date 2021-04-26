//
//  LineStyle.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

/**
 Model for controlling the styling for individual lines.
 */
public struct LineStyle: CTLineStyle, Hashable {
    
    public var lineColour: ColourStyle
    public var lineType: LineType
    public var strokeStyle: Stroke
    public var ignoreZero: Bool
    
    /// Style of the line.
    /// 
    /// - Parameters:
    ///   - lineColour: Colour styling of the line.
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(
        lineColour: ColourStyle = ColourStyle(colour: .red),
        lineType: LineType = .curvedLine,
        strokeStyle: Stroke = Stroke(),
        ignoreZero: Bool = false
    ) {
        self.lineColour = lineColour
        self.lineType = lineType
        self.strokeStyle = strokeStyle
        self.ignoreZero = ignoreZero
    }
}
