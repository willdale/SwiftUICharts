//
//  BarChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

public struct BarChartStyle: CTBarChartStyle {
        
    /// Placement of the information box that appears on touch input.
    public var infoBoxPlacement : InfoBoxPlacement
        
    /// Style of the vertical lines breaking up the chart.
    public var xAxisGridStyle   : GridStyle
    /// Style of the horizontal lines breaking up the chart.
    public var yAxisGridStyle   : GridStyle
    
    /// Location of the X axis labels - Top or Bottom
    public var xAxisLabelPosition: XAxisLabelPosistion
    /// Where the label data come from. DataPoint or xAxisLabels
    public var xAxisLabelsFrom   : LabelsFrom

    /// Location of the X axis labels - Leading or Trailing
    public var yAxisLabelPosition    : YAxisLabelPosistion
    /// Number Of Labels on Y Axis
    public var yAxisNumberOfLabels   : Int
    
    /// Gobal control of animations.
    public var globalAnimation : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing
    ///   - yAxisNumberOfLabel: Number Of Labels on Y Axis
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement    : InfoBoxPlacement      = .floating,
                xAxisGridStyle      : GridStyle             = GridStyle(),
                yAxisGridStyle      : GridStyle             = GridStyle(),
                xAxisLabelPosition  : XAxisLabelPosistion   = .bottom,
                xAxisLabelsFrom     : LabelsFrom            = .dataPoint,
                yAxisLabelPosition  : YAxisLabelPosistion   = .leading,
                yAxisNumberOfLabels : Int                   = 10,
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement   = infoBoxPlacement
        self.xAxisGridStyle     = xAxisGridStyle
        self.yAxisGridStyle     = yAxisGridStyle

        self.xAxisLabelPosition  = xAxisLabelPosition
        self.xAxisLabelsFrom     = xAxisLabelsFrom
        self.yAxisLabelPosition  = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        
        self.globalAnimation     = globalAnimation
    }
}
