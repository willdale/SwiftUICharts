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
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxPlacement: InfoBoxPlacement = .floating
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxContentAlignment: InfoBoxAlignment = .vertical
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxValueFont: Font = .title3
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxValueColour: Color = Color.primary
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxDescriptionFont: Font = .caption
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxDescriptionColour: Color = Color.primary
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxBackgroundColour: Color = Color.systemsBackground
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxBorderColour: Color = Color.clear
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public var infoBoxBorderStyle: StrokeStyle = StrokeStyle(lineWidth: 0)
    
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
    }
}
