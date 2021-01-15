//
//  ChartStyle.swift
//  
//
//  Created by Will Dale on 12/01/2021.
//

import SwiftUI

/// Model for controlling the overall aesthetic of the chart.
public struct ChartStyle {
        
    /// Placement of the information box that appears on touch input.
    public var infoBoxPlacement : InfoBoxPlacement
        
    /// Style of the vertical lines breaking up the chart.
    public var xAxisGridStyle   : GridStyle
    /// Style of the horizontal lines breaking up the chart.
    public var yAxisGridStyle   : GridStyle
    
    /// Style of the labels on the X axis.
    public var xAxisLabels      : XAxisLabelSetup
    /// Style of the labels on the Y axis.
    public var yAxisLabels      : YAxisLabelSetup
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - xAxisLabels: Style of the labels on the X axis.
    ///   - yAxisLabels: Style of the labels on the Y axis.
    public init(infoBoxPlacement: InfoBoxPlacement  = .floating,
                xAxisGridStyle  : GridStyle         = GridStyle(),
                yAxisGridStyle  : GridStyle         = GridStyle(),
                xAxisLabels     : XAxisLabelSetup   = XAxisLabelSetup(),
                yAxisLabels     : YAxisLabelSetup   = YAxisLabelSetup()
    ) {
        self.infoBoxPlacement   = infoBoxPlacement
        self.xAxisGridStyle     = xAxisGridStyle
        self.yAxisGridStyle     = yAxisGridStyle
        self.xAxisLabels        = xAxisLabels
        self.yAxisLabels        = yAxisLabels
    }
}


