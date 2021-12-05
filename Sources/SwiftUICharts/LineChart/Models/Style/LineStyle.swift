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

    public var lineColour: ChartColour
    public var lineType: LineType
    public var strokeStyle: StrokeStyle
    
    /// Style of the line.
    ///
    /// - Parameters:
    ///   - colour: Colour styling of the line.
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    public init(
        lineColour: ChartColour = .colour(colour: .red),
        lineType: LineType = .curvedLine,
        strokeStyle: StrokeStyle = StrokeStyle()
    ) {
        self.lineColour = lineColour
        self.lineType = lineType
        self.strokeStyle = strokeStyle
    }
}
