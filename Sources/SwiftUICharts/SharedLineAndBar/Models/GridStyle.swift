//
//  GridStyle.swift
//  
//
//  Created by Will Dale on 13/01/2021.
//

import SwiftUI

/**
 Control for the look of the Grid
 */
public struct GridStyle {
    
    /**
     Number of lines to break up the axis
     */
    public var numberOfLines: Int
    
    /**
     Line Colour
     */
    public var lineColour: Color
    
    /**
     Line Width
     */
    public var lineWidth: CGFloat
    
    /**
     Dash
     */
    public var dash: [CGFloat]
    
    /**
     Dash Phase
     */
    public var dashPhase: CGFloat
    
    /// Model for controlling the look of the Grid
    /// - Parameters:
    ///   - numberOfLines: Number of lines to break up the axis
    ///   - lineColour: Line Colour
    ///   - lineWidth: Line Width
    ///   - dash: Dash
    ///   - dashPhase: Dash Phase
    public init(
        numberOfLines: Int = 10,
        lineColour: Color = Color(.gray).opacity(0.25),
        lineWidth: CGFloat = 1,
        dash: [CGFloat] = [10],
        dashPhase: CGFloat = 0
    ) {
        self.numberOfLines = numberOfLines
        self.lineColour = lineColour
        self.lineWidth = lineWidth
        self.dash = dash
        self.dashPhase = dashPhase
    }
}
