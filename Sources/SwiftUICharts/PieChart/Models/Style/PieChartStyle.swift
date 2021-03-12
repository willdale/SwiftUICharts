//
//  PieChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/**
 Model for controlling the overall aesthetic of the chart.
 
 ```
 PieChartStyle(infoBoxPlacement: .fixed,
               infoBoxValueColour: Color.primary,
               infoBoxDescriptionColour: Color(.systemBackground),
               globalAnimation: .linear(duration: 1))
 ```
 */
public struct PieChartStyle: CTPieChartStyle {
        
    public var infoBoxPlacement         : InfoBoxPlacement
    public var infoBoxValueColour       : Color
    public var infoBoxDescriptionColour : Color
    public var infoBoxBackgroundColour  : Color
    
    public var globalAnimation : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColour: Colour of the description part of the touch info.
    ///   - infoBoxBackgroundColour: Background colour of touch info.
    ///   - globalAnimation: Global control of animations.
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColour: Color             = Color.primary,
                infoBoxBackgroundColour : Color             = Color.systemsBackground,
                globalAnimation         : Animation         = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement         = infoBoxPlacement
        self.infoBoxValueColour       = infoBoxValueColour
        self.infoBoxDescriptionColour = infoBoxDescriptionColour
        self.infoBoxBackgroundColour  = infoBoxBackgroundColour
        self.globalAnimation          = globalAnimation
    }
}


