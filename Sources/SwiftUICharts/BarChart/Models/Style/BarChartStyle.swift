//
//  BarChartStyle.swift
//  
//
//  Created by Will Dale on 25/01/2021.
//

import SwiftUI


/**
 Control of the overall aesthetic of the bar chart.
 
 Controls the look of the chart as a whole, not including any styling
 specific to the data set(s),
 */
public struct BarChartStyle: CTBarChartStyle {
    
    public var infoBoxPlacement: InfoBoxPlacement
    public var infoBoxContentAlignment: InfoBoxAlignment
    
    public var infoBoxValueFont: Font
    public var infoBoxValueColour: Color
    
    public var infoBoxDescriptionFont: Font
    public var infoBoxDescriptionColour: Color
    
    public var infoBoxBackgroundColour: Color
    public var infoBoxBorderColour: Color
    public var infoBoxBorderStyle: StrokeStyle
    
    public var markerType: BarMarkerType
    
    public var xAxisGridStyle: GridStyle
    
    public var xAxisLabelPosition: XAxisLabelPosistion
    public var xAxisLabelFont: Font
    public var xAxisLabelColour: Color
    public var xAxisLabelsFrom: LabelsFrom
    
    public var xAxisTitle: String?
    public var xAxisTitleFont: Font
    public var xAxisTitleColour: Color
    public var xAxisBorderColour: Color?

    public var yAxisGridStyle: GridStyle
    
    public var yAxisLabelPosition: YAxisLabelPosistion
    public var yAxisLabelFont: Font
    public var yAxisLabelColour: Color
    public var yAxisNumberOfLabels: Int
    public var yAxisLabelType: YAxisLabelType
    
    public var yAxisTitle: String?
    public var yAxisTitleFont: Font
    public var yAxisTitleColour: Color
    public var yAxisBorderColour: Color?

    public var baseline: Baseline
    public var topLine: Topline
    
    public var globalAnimation: Animation
    
    /// Model for controlling the overall aesthetic of the Bar Chart.
    ///
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
    ///
    ///   - markerType: Where the marker lines come from to meet at a specified point.
    ///
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom.
    ///   - xAxisLabelFont: Font of the labels on the X axis.
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels.
    ///   - xAxisLabelColour: Text Colour for the labels on the X axis.
    ///
    ///   - xAxisTitle: Label to display next to the chart giving info about the axis.
    ///   - xAxisTitleFont: Font of the x axis title.
    ///   - xAxisTitleColour: Colour of the x axis title.
    ///
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing.
    ///   - yAxisLabelFont: Font of the labels on the Y axis.
    ///   - yAxisLabelColour: Text Colour for the labels on the Y axis.
    ///   - yAxisNumberOfLabels: Number Of Labels on Y Axis.
    ///   - yAxisLabelType: Option to choose between auto generated, numeric labels or custum array of strings.
    ///
    ///   - yAxisTitle: Label to display next to the chart giving info about the axis.
    ///   - yAxisTitleFont: Font of the y axis title.
    ///   - yAxisTitleColour: Colour of the y axis title.
    ///
    ///   - baseline: Whether the chart is drawn from baseline of zero or the minimum datapoint value.
    ///   - topLine: Where to finish drawing the chart from. Data set maximum or custom.
    ///
    ///   - globalAnimation: Global control of animations.
    public init(
        infoBoxPlacement: InfoBoxPlacement  = .floating,
        infoBoxContentAlignment: InfoBoxAlignment  = .vertical,
        
        infoBoxValueFont: Font = .title3,
        infoBoxValueColour: Color = Color.primary,
        
        infoBoxDescriptionFont: Font = .caption,
        infoBoxDescriptionColour: Color = Color.primary,
        
        infoBoxBackgroundColour: Color = Color.systemsBackground,
        infoBoxBorderColour: Color = Color.clear,
        infoBoxBorderStyle: StrokeStyle = StrokeStyle(lineWidth: 0),
        
        markerType: BarMarkerType = .full(),
        
        xAxisGridStyle: GridStyle = GridStyle(),
        
        xAxisLabelPosition: XAxisLabelPosistion = .bottom,
        xAxisLabelFont: Font = .caption,
        xAxisLabelColour: Color = Color.primary,
        xAxisLabelsFrom: LabelsFrom = .dataPoint(rotation: .degrees(0)),
        
        xAxisTitle: String? = nil,
        xAxisTitleFont: Font = .caption,
        xAxisTitleColour: Color = .primary,
        
        yAxisGridStyle: GridStyle = GridStyle(),
        
        yAxisLabelPosition: YAxisLabelPosistion = .leading,
        yAxisLabelFont: Font = .caption,
        yAxisLabelColour: Color = Color.primary,
        yAxisNumberOfLabels: Int = 10,
        yAxisLabelType: YAxisLabelType = .numeric,
        
        yAxisTitle: String? = nil,
        yAxisTitleFont: Font = .caption,
        yAxisTitleColour: Color = .primary,
        
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue,
        
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
        
        self.markerType = markerType
        
        self.xAxisGridStyle = xAxisGridStyle
        
        self.xAxisLabelPosition = xAxisLabelPosition
        self.xAxisLabelFont = xAxisLabelFont
        self.xAxisLabelColour = xAxisLabelColour
        self.xAxisLabelsFrom = xAxisLabelsFrom
        
        self.xAxisTitle = xAxisTitle
        self.xAxisTitleFont = xAxisTitleFont
        self.xAxisTitleColour = xAxisTitleColour
        
        self.yAxisGridStyle = yAxisGridStyle
        
        self.yAxisLabelPosition = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        self.yAxisLabelFont = yAxisLabelFont
        self.yAxisLabelColour = yAxisLabelColour
        self.yAxisLabelType = yAxisLabelType
        
        self.yAxisTitle = yAxisTitle
        self.yAxisTitleFont = yAxisTitleFont
        self.yAxisTitleColour = yAxisTitleColour
        
        self.baseline = baseline
        self.topLine = topLine
        
        self.globalAnimation = globalAnimation
    }
}
