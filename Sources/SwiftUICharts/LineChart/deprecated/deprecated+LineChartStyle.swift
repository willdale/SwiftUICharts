//
//  deprecated+LineChartStyle.swift
//  
//
//  Created by Will Dale on 30/10/2021.
//

import SwiftUI

/**
 Control of the overall aesthetic of the line chart.
 
 Controls the look of the chart as a whole, not including any styling
 specific to the data set(s),
 */
@available(*, deprecated, message: "Has been de-centralised")
public struct LineChartStyle: CTLineChartStyle {
    
    // MARK: Deprecations
    @available(*, deprecated, message: "Moved to view \".infoDisplay\"")
    public var markerType: LineMarkerType
    
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
    
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    public var xAxisLabelPosition: XAxisLabelPosistion
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    public var xAxisLabelFont: Font
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    public var xAxisLabelColour: Color
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    public var xAxisLabelsFrom: LabelsFrom
    
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitle: String?
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitleFont: Font
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitleColour: Color
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisBorderColour: Color?

    @available(*, deprecated, message: "Moved to view \".xAxisGrid\"")
    public var xAxisGridStyle: GridStyle
    @available(*, deprecated, message: "Moved to view \".xAxisGrid\"")
    public var yAxisGridStyle: GridStyle
    
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    public var yAxisLabelPosition: YAxisLabelPosistion
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    public var yAxisLabelFont: Font
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    public var yAxisLabelColour: Color
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    public var yAxisNumberOfLabels: Int
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    public var yAxisLabelType: YAxisLabelType
    
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitle: String?
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitleFont: Font
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitleColour: Color
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisBorderColour: Color?

    @available(*, deprecated, message: "Moved in the main chart data model")
    public var baseline: Baseline
    @available(*, deprecated, message: "Moved in the main chart data model")
    public var topLine: Topline
    
    @available(*, deprecated, message: "Has been de-centralised")
    public var globalAnimation: Animation
    
    // MARK: Init
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - markerType: Where the marker lines come from to meet at a specified point.
    ///
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom.
    ///   - xAxisLabelFont: Font of the labels on the X axis.
    ///   - xAxisLabelColour: Text Colour for the labels on the X axis.
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels.
    ///
    ///   - xAxisTitle: Label to display next to the chart giving info about the axis.
    ///   - xAxisTitleFont: Font of the x axis title.
    ///   - xAxisTitleColour: Colour of the x axis title.
    ///   - xAxisBorderColour: Colour of the x axis border.
    ///
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing.
    ///   - yAxisLabelFont: Font of the labels on the Y axis.
    ///   - yAxisLabelColour: Text Colour for the labels on the Y axis.
    ///   - yAxisNumberOfLabels: Number Of Labels on Y Axis.
    ///   - yAxisLabelType: Option to add custom Strings to Y axis rather than auto generated numbers.
    ///
    ///   - yAxisTitle: Label to display next to the chart giving info about the axis.
    ///   - yAxisTitleFont: Font of the y axis title.
    ///   - yAxisTitleColour: Colour of the y axis title.
    ///   - yAxisBorderColour: Colour of the y axis border.
    ///
    ///   - baseline: Whether the chart is drawn from baseline of zero or the minimum datapoint value.
    ///   - topLine: Where to finish drawing the chart from. Data set maximum or custom.
    ///
    ///   - globalAnimation: Global control of animations.
    public init(
        markerType: LineMarkerType = .indicator,
        
        xAxisGridStyle: GridStyle = GridStyle(),
        
        xAxisLabelPosition: XAxisLabelPosistion = .bottom,
        xAxisLabelFont: Font = .caption,
        xAxisLabelColour: Color = Color.primary,
        xAxisLabelsFrom: LabelsFrom = .dataPoint(rotation: .degrees(0)),
        
        xAxisTitle: String? = nil,
        xAxisTitleFont: Font = .caption,
        xAxisTitleColour: Color = .primary,
        xAxisBorderColour: Color? = nil,

        yAxisGridStyle: GridStyle = GridStyle(),
        
        yAxisLabelPosition: YAxisLabelPosistion = .leading,
        yAxisLabelFont: Font = .caption,
        yAxisLabelColour: Color = Color.primary,
        yAxisNumberOfLabels: Int = 10,
        yAxisLabelType: YAxisLabelType = .numeric,
        
        yAxisTitle: String? = nil,
        yAxisTitleFont: Font = .caption,
        yAxisTitleColour: Color = .primary,
        yAxisBorderColour: Color? = nil,

        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue,
        
        globalAnimation: Animation = Animation.linear(duration: 1)
    ) {
        self.markerType = markerType
        
        self.xAxisGridStyle = xAxisGridStyle
        
        self.xAxisLabelPosition = xAxisLabelPosition
        self.xAxisLabelFont = xAxisLabelFont
        self.xAxisLabelsFrom = xAxisLabelsFrom
        self.xAxisLabelColour = xAxisLabelColour
        
        self.xAxisTitle = xAxisTitle
        self.xAxisTitleFont = xAxisTitleFont
        self.xAxisTitleColour = xAxisTitleColour
        self.xAxisBorderColour = xAxisBorderColour
        
        self.yAxisGridStyle = yAxisGridStyle
        
        self.yAxisLabelPosition = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        self.yAxisLabelFont = yAxisLabelFont
        self.yAxisLabelColour = yAxisLabelColour
        self.yAxisLabelType = yAxisLabelType
        
        self.yAxisTitle = yAxisTitle
        self.yAxisTitleFont = yAxisTitleFont
        self.yAxisTitleColour = yAxisTitleColour
        self.yAxisBorderColour = yAxisBorderColour

        self.baseline = baseline
        self.topLine = topLine
        
        self.globalAnimation = globalAnimation
    }
}
