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
        
    public var lineColour  : ColourStyle
    public var lineType    : LineType
    public var strokeStyle : Stroke

    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
        
     The default is false.
    */
    public var ignoreZero  : Bool
        
    /// Style of the line.
    /// - Parameters:
    ///   - lineColour: Colour styling of the line.
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(lineColour  : ColourStyle = ColourStyle(colour: .red),
                lineType    : LineType   = .curvedLine,
                strokeStyle : Stroke = Stroke(lineWidth : 3,
                                              lineCap   : .round,
                                              lineJoin  : .round,
                                              miterLimit: 10,
                                              dash      : [CGFloat](),
                                              dashPhase : 0),
                ignoreZero  : Bool       = false
    ) {
        self.lineColour  = lineColour
        self.lineType    = lineType
        self.strokeStyle = strokeStyle
        self.ignoreZero  = ignoreZero
    }
}
