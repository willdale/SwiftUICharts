//
//  PieChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/// Model for controlling the overall aesthetic of the chart.
public struct PieChartStyle: CTPieChartStyle {
        
    /// Placement of the information box that appears on touch input.
    public var infoBoxPlacement : InfoBoxPlacement
    
    /// Gobal control of animations.
    public var globalAnimation : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement    : InfoBoxPlacement      = .floating,
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement   = infoBoxPlacement
        self.globalAnimation     = globalAnimation
    }
}


