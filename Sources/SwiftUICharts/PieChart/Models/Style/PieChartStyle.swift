//
//  PieChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/**
 Model for controlling the overall aesthetic of the chart.
 */
public struct PieChartStyle: CTPieChartStyle {
    
    // MARK: Deprecations
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxPlacement: InfoBoxPlacement
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxContentAlignment: InfoBoxAlignment
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxValueFont: Font
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxValueColour: Color
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxDescriptionFont: Font
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxDescriptionColour: Color
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxBackgroundColour: Color
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxBorderColour: Color
    @available(*, deprecated, message: "Please use \"touchDisplay\" instead.")
    public var infoBoxBorderStyle: StrokeStyle
    
    // MARK: Properties
    public var globalAnimation: Animation
    
    // MARK: Init
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxContentAlignment: Alignment of the content inside of the information box
    ///
    ///   - infoBoxValueFont: Font for the value part of the touch info.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///
    ///   - infoBoxDescriptionFont: Font for the description part of the touch info.
    ///   - infoBoxDescriptionColour: Colour of the description part of the touch info.
    ///
    ///   - infoBoxBackgroundColour: Background colour of touch info.
    ///   - infoBoxBorderColour: Border colour of the touch info.
    ///   - infoBoxBorderStyle: Border style of the touch info.
    ///   - globalAnimation: Global control of animations.
    public init(
        globalAnimation: Animation = Animation.linear(duration: 1)
    ) {
        self.globalAnimation = globalAnimation
        
        self.infoBoxPlacement = .floating
        self.infoBoxContentAlignment = .vertical
        self.infoBoxValueFont = .title3
        self.infoBoxValueColour = Color.primary
        self.infoBoxDescriptionFont = .caption
        self.infoBoxDescriptionColour = Color.primary
        self.infoBoxBackgroundColour = Color.systemsBackground
        self.infoBoxBorderColour = Color.clear
        self.infoBoxBorderStyle = StrokeStyle(lineWidth: 0)
    }
}
