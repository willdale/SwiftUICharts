//
//  PieChartStyleDeprecated.swift
//  
//
//  Created by Will Dale on 30/10/2021.
//

import SwiftUI

extension PieChartStyle {
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
    @available(*, deprecated, message: "Please use \"other init\" instead.")
    public init(
        infoBoxPlacement: InfoBoxPlacement = .floating,
        infoBoxContentAlignment: InfoBoxAlignment = .vertical,
        infoBoxValueFont: Font = .title3,
        infoBoxValueColour: Color = Color.primary,
        infoBoxDescriptionFont: Font = .caption,
        infoBoxDescriptionColour: Color = Color.primary,
        infoBoxBackgroundColour: Color = Color.systemsBackground,
        infoBoxBorderColour: Color = Color.clear,
        infoBoxBorderStyle: StrokeStyle = StrokeStyle(lineWidth: 0),
        
        globalAnimation: Animation = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement = infoBoxPlacement
        self.infoBoxContentAlignment = infoBoxContentAlignment
        
        self.infoBoxValueFont = infoBoxValueFont
        self.infoBoxValueColour = infoBoxValueColour
        
        self.infoBoxDescriptionFont = infoBoxDescriptionFont
        self.infoBoxDescriptionColour = infoBoxDescriptionColour
        
        self.infoBoxBackgroundColour = infoBoxBackgroundColour
        self.infoBoxBorderColour = infoBoxBorderColour
        self.infoBoxBorderStyle = infoBoxBorderStyle
        self.globalAnimation = globalAnimation
    }
}
