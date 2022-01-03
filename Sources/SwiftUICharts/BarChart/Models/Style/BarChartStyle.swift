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
    // MARK: Deprecations
    
    @available(*, deprecated, message: "Moved to view \".infoDisplay\"")
    public var markerType: BarMarkerType
    
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
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    
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
    
    @available(*, deprecated, message: "Moved to view \".xAxisGrid\"")
    public var xAxisGridStyle: GridStyle
    @available(*, deprecated, message: "Moved to view \".xAxisGrid\"")
    public var yAxisGridStyle: GridStyle
    
    @available(*, deprecated, message: "Moved to view \".axisBorder\"")
    public var xAxisBorderColour: Color?
    @available(*, deprecated, message: "Moved to view \".axisBorder\"")
    public var yAxisBorderColour: Color?
    
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitle: String?
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitleFont: Font
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var xAxisTitleColour: Color
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitle: String?
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitleFont: Font
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    public var yAxisTitleColour: Color
    
    // MARK: Properties

    public var baseline: Baseline
    public var topLine: Topline
    
    public var globalAnimation: Animation
    
    // MARK: Init
    public init(
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
