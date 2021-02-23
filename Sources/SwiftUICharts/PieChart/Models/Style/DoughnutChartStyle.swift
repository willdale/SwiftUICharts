//
//  DoughnutChartStyle.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/**
 Model for controlling the overall aesthetic of the chart.
 
 ```
 DoughnutChartStyle(infoBoxPlacement: .floating,
                    globalAnimation: .linear(duration: 1),
                    strokeWidth: 60)
 ```
 */
public struct DoughnutChartStyle: CTDoughnutChartStyle {
        
    public var infoBoxPlacement         : InfoBoxPlacement
    public var infoBoxValueColour       : Color
    public var infoBoxDescriptionColour : Color
    
    public var globalAnimation  : Animation
    
    public var strokeWidth      : CGFloat
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColour: Colour of the description part of the touch info.
    ///   - globalAnimation: Global control of animations.
    ///   - strokeWidth: Width / Delta of the Doughnut Chart
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColour: Color             = Color.primary,
                globalAnimation         : Animation         = Animation.linear(duration: 1),
                strokeWidth             : CGFloat           = 30
    ) {
        self.infoBoxPlacement         = infoBoxPlacement
        self.infoBoxValueColour       = infoBoxValueColour
        self.infoBoxDescriptionColour = infoBoxDescriptionColour
        self.globalAnimation          = globalAnimation
        self.strokeWidth              = strokeWidth
    }
}
