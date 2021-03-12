//
//  LineChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI

/**
 Control of the overall aesthetic of the line chart.
 
 Controls the look of the chart as a whole, not including any styling
 specific to the data set(s),
 */
public struct LineChartStyle: CTLineChartStyle {
    
    public var infoBoxPlacement        : InfoBoxPlacement
    public var infoBoxValueColour      : Color
    public var infoBoxDescriptionColour: Color
    public var infoBoxBackgroundColour : Color
    
    public var markerType              : LineMarkerType
        
    public var xAxisGridStyle       : GridStyle
    public var xAxisLabelPosition   : XAxisLabelPosistion
    public var xAxisLabelColour     : Color
    public var xAxisLabelsFrom      : LabelsFrom
    public var xAxisTitle           : String?
    
    public var yAxisGridStyle       : GridStyle
    public var yAxisLabelPosition   : YAxisLabelPosistion
    public var yAxisLabelColour     : Color
    public var yAxisNumberOfLabels  : Int
    public var yAxisTitle           : String?
    
    public var baseline             : Baseline
    public var topLine              : Topline
    
    public var globalAnimation      : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColour: Colour of the description part of the touch info.
    ///   - infoBoxBackgroundColour: Background colour of touch info.
    ///
    ///   - markerType: Where the marker lines come from to meet at a specified point.
    ///
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom.
    ///   - xAxisLabelColour: Text Colour for the labels on the X axis.
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels.
    ///   - xAxisTitle: Label to display next to the chart giving info about the axis.
    ///
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing.
    ///   - yAxisLabelColour: Text Colour for the labels on the Y axis.
    ///   - yAxisNumberOfLabel: Number Of Labels on Y Axis.
    ///   - yAxisTitle: Label to display next to the chart giving info about the axis.
    ///
    ///   - baseline: Whether the chart is drawn from baseline of zero or the minimum datapoint value.
    ///   - topLine: Where to finish drawing the chart from. Data set maximum or custom.
    ///
    ///   - globalAnimation: Global control of animations.
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColour: Color             = Color.primary,
                infoBoxBackgroundColour : Color             = Color.systemsBackground,
                
                markerType              : LineMarkerType    = .indicator(style: DotStyle()),
                
                xAxisGridStyle      : GridStyle             = GridStyle(),
                xAxisLabelPosition  : XAxisLabelPosistion   = .bottom,
                xAxisLabelColour    : Color                 = Color.primary,
                xAxisLabelsFrom     : LabelsFrom            = .dataPoint(rotation: .degrees(0)),
                xAxisTitle          : String?               = nil,
                
                yAxisGridStyle      : GridStyle             = GridStyle(),
                yAxisLabelPosition  : YAxisLabelPosistion   = .leading,
                yAxisLabelColour    : Color                 = Color.primary,
                yAxisNumberOfLabels : Int                   = 10,
                yAxisTitle          : String?               = nil,

                baseline            : Baseline              = .minimumValue,
                topLine             : Topline               = .maximumValue,
                
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement         = infoBoxPlacement
        self.infoBoxValueColour       = infoBoxValueColour
        self.infoBoxDescriptionColour = infoBoxDescriptionColour
        self.infoBoxBackgroundColour  = infoBoxBackgroundColour
        
        self.markerType          = markerType
        
        self.xAxisGridStyle      = xAxisGridStyle
        self.xAxisLabelPosition  = xAxisLabelPosition
        self.xAxisLabelsFrom     = xAxisLabelsFrom
        self.xAxisLabelColour    = xAxisLabelColour
        self.xAxisTitle          = xAxisTitle
        
        self.yAxisGridStyle      = yAxisGridStyle
        self.yAxisLabelPosition  = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        self.yAxisLabelColour    = yAxisLabelColour
        self.yAxisTitle          = yAxisTitle
        
        self.baseline            = baseline
        self.topLine             = topLine
        
        self.globalAnimation     = globalAnimation
    }
}
