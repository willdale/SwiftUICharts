//
//  RangedLineStyle.swift
//  
//
//  Created by Will Dale on 02/03/2021.
//

import SwiftUI
/**
 Model for controlling the aesthetic of the ranged line chart.
 
 # Example
 ```
 RangedLineStyle(lineColour: ColourStyle(colour: .red),
                 fillColour: ColourStyle(colour: Color(.blue).opacity(0.25)),
                 lineType  : .curvedLine))
 ```
 */
public struct RangedLineStyle: CTRangedLineStyle, Hashable {
    
    public var lineColour : ColourStyle
    public var fillColour : ColourStyle
    
    public var lineType    : LineType
    public var strokeStyle : Stroke

    /**
     Whether the chart should skip data points who's value is 0.
     
     This might be useful when showing trends over time but each day does not necessarily have data.
        
     The default is false.
    */
    public var ignoreZero  : Bool
        
    // MARK: Initializer
    /// Initialize the styling for ranged line chart.
    ///
    /// - Parameters:
    ///   - colour: Single Colour
    ///   - lineType: Drawing style of the line
    ///   - strokeStyle: Stroke Style
    ///   - ignoreZero: Whether the chart should skip data points who's value is 0.
    public init(lineColour  : ColourStyle = ColourStyle(),
                fillColour  : ColourStyle = ColourStyle(),
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
        self.fillColour  = fillColour
        self.lineType    = lineType
        self.strokeStyle = strokeStyle
        self.ignoreZero  = ignoreZero
    }
}
