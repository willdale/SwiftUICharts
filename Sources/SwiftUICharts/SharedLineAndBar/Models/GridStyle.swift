//
//  GridStyle.swift
//  
//
//  Created by Will Dale on 13/01/2021.
//

import SwiftUI

/**
 Controlling for the look of the Grid
 
 # Example
 ```
 GridStyle(numberOfLines: 7,
           lineColour   : .gray,
           lineWidth    : 1,
           dash         : [8],
           dashPhase    : 0)
 ```
 */
public struct GridStyle {
    
    /// Number of lines to break up the axis
    public var numberOfLines: Int
    
    public var lineColour   : Color
    public var lineWidth    : CGFloat
    public var dash         : [CGFloat]
    public var dashPhase    : CGFloat
    
    /// Model for controlling the look of the Grid
    /// - Parameters:
    ///   - numberOfLines: Number of lines to break up the axis
    ///   - lineColour: Line Colour
    ///   - lineWidth: Line Width
    ///   - dash: Dash
    ///   - dashPhase: Dash Phase
    public init(numberOfLines: Int       = 10,
                lineColour   : Color     = Color(.gray).opacity(0.25),
                lineWidth    : CGFloat   = 1,
                dash         : [CGFloat] = [10],
                dashPhase    : CGFloat   = 0
    ) {
        self.numberOfLines  = numberOfLines
        self.lineColour     = lineColour
        self.lineWidth      = lineWidth
        self.dash           = dash
        self.dashPhase      = dashPhase
    }
}
