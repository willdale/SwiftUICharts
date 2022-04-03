//
//  deprecated+CTChartStyle.swift
//  
//
//  Created by Will Dale on 03/01/2022.
//

import SwiftUI

/**
 Protocol to set the styling data for the chart.
 */
@available(*, deprecated, message: "Has been de-centralised")
public protocol CTChartStyle {
    
    /**
     Placement of the information box that appears on touch input.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxPlacement: InfoBoxPlacement { get set }
    
    /**
     Placement of the information box that appears on touch input.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxContentAlignment: InfoBoxAlignment { get set }
    
    /**
     Font for the value part of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxValueFont: Font { get set }
    
    /**
     Colour of the value part of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxValueColour: Color { get set }
    
    /**
     Font for the description part of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxDescriptionFont: Font { get set }
    
    /**
     Colour of the description part of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxDescriptionColour: Color { get set }
    
    /**
     Colour of the background of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxBackgroundColour: Color { get set }
    
    /**
     Border colour of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxBorderColour: Color { get set }
    
    /**
     Border style of the touch info.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    var infoBoxBorderStyle: StrokeStyle { get set }
    
    /**
     Global control of animations.
     
     ```
     Animation.linear(duration: 1)
     ```
     */
    @available(*, deprecated, message: "Has been de-centralised")
    var globalAnimation: Animation { get set }
}
