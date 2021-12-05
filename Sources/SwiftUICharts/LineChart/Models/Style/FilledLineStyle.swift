//
//  FilledLineStyle.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI

public struct FilledLineStyle: CTLineStyle, Hashable {

    public var lineColour: ChartColour
    public var fillColour: ChartColour
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
        fillColour: ChartColour = .gradient(colours: [Color.red.opacity(0.50),Color.red.opacity(0.00)], startPoint: .top, endPoint: .bottom),
        lineType: LineType = .curvedLine,
        strokeStyle: StrokeStyle = StrokeStyle()
    ) {
        self.lineColour = lineColour
        self.fillColour = fillColour
        self.lineType = lineType
        self.strokeStyle = strokeStyle
    }
}
