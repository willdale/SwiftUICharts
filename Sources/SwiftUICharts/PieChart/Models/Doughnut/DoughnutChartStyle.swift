//
//  DoughnutChartStyle.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/// Model for controlling the overall aesthetic of the chart.
public struct DoughnutChartStyle: CTDoughnutChartStyle {
        
    /// Placement of the information box that appears on touch input.
    public var infoBoxPlacement : InfoBoxPlacement
    
    /// Gobal control of animations.
    public var globalAnimation : Animation
    
    public var strokeWidth      : CGFloat
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement    : InfoBoxPlacement      = .floating,
                globalAnimation     : Animation             = Animation.linear(duration: 1),
                strokeWidth         : CGFloat               = 30
    ) {
        self.infoBoxPlacement   = infoBoxPlacement
        self.globalAnimation    = globalAnimation
        self.strokeWidth        = strokeWidth
    }
}