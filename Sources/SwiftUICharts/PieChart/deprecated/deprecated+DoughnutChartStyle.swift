//
//  deprecated+DoughnutChartStyle.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/// A protocol to extend functionality of `CTPieAndDoughnutChartStyle` specifically for Doughnut Charts.
@available(*, deprecated, message: "")
public protocol CTDoughnutChartStyle {
    /// Width / Delta of the Doughnut Chart
    var strokeWidth: CGFloat { get set }
}

/**
 Model for controlling the overall aesthetic of the chart.
 */
@available(*, deprecated, message: "")
public struct DoughnutChartStyle: CTDoughnutChartStyle {
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
    
    @available(*, deprecated, message: "")
    public var globalAnimation: Animation
    
    @available(*, deprecated, message: "Moved to data model")
    public var strokeWidth: CGFloat
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxContentAlignment: Alignment of the content inside of the information box
    ///   - infoBoxValueFont: Font for the value part of the touch info.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionFont: Font for the description part of the touch info.
    ///   - infoBoxDescriptionColour: Colour of the description part of the touch info.
    ///   - infoBoxBackgroundColour: Background colour of touch info.
    ///   - infoBoxBorderColour: Border colour of the touch info.
    ///   - infoBoxBorderStyle: Border style of the touch info.
    ///   - globalAnimation: Global control of animations.
    ///   - strokeWidth: Width / Delta of the Doughnut Chart
    public init(
        globalAnimation: Animation = Animation.linear(duration: 1),
        strokeWidth: CGFloat = 30
    ) {
        self.globalAnimation = globalAnimation
        self.strokeWidth = strokeWidth
    }
}
