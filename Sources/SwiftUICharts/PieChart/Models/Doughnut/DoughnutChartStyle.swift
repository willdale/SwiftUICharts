//
//  DoughnutChartStyle.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/// Model for controlling the overall aesthetic of the chart.
public struct DoughnutChartStyle: CTDoughnutChartStyle {
        
    public var infoBoxPlacement         : InfoBoxPlacement
    public var infoBoxValueColour       : Color
    public var infoBoxDescriptionColor  : Color
    
    public var globalAnimation : Animation
    
    public var strokeWidth      : CGFloat
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColor: Colour of the description part of the touch info.
    ///   - globalAnimation: Gobal control of animations.
    ///   - strokeWidth: Width / Delta of the Doughnut Chart
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColor : Color             = Color.primary,
                globalAnimation         : Animation         = Animation.linear(duration: 1),
                strokeWidth             : CGFloat           = 30
    ) {
        self.infoBoxPlacement        = infoBoxPlacement
        self.infoBoxValueColour      = infoBoxValueColour
        self.infoBoxDescriptionColor = infoBoxDescriptionColor
        self.globalAnimation         = globalAnimation
        self.strokeWidth             = strokeWidth
    }
}
