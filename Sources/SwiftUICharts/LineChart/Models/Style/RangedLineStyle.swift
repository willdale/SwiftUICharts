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
    
    public var lineColour: ChartColour
    public var fillColour: ChartColour
    public var lineType: LineType
    public var strokeStyle: StrokeStyle
    public var ignoreZero: Bool
    
    // MARK: Initializer
    /// Initialize the styling for ranged line chart.
    ///
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(lineColour: ChartColour = .colour(colour: .red),
                fillColour: ChartColour = .colour(colour: .red),
                lineType: LineType = .curvedLine,
                strokeStyle: StrokeStyle = StrokeStyle(),
                ignoreZero: Bool = false
    ) {
        self.lineColour  = lineColour
        self.fillColour  = fillColour
        self.lineType    = lineType
        self.strokeStyle = strokeStyle
        self.ignoreZero  = ignoreZero
    }
}
