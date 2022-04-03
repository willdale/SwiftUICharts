//
//  deprecated+CTLineBarChartStyle.swift
//  
//
//  Created by Will Dale on 03/01/2022.
//

import SwiftUI

/// A protocol to extend functionality of `CTChartStyle` specifically for  Line and Bar Charts.
@available(*, deprecated, message: "Has been de-centralised")
public protocol CTLineBarChartStyle: CTChartStyle {
    /// Location of the X axis labels - Top or Bottom.
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    var xAxisLabelPosition: XAxisLabelPosistion { get set }
    
    /// Font of the labels on the X axis.
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    var xAxisLabelFont: Font { get set }
    
    /// Text Colour for the labels on the X axis.
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    var xAxisLabelColour: Color { get set }
    
    /// Where the label data come from. DataPoint or ChartData.
    @available(*, deprecated, message: "Moved to view \".xAxisLabels\"")
    var xAxisLabelsFrom: LabelsFrom { get set }
    
    /// Location of the X axis labels - Leading or Trailing.
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    var yAxisLabelPosition: YAxisLabelPosistion { get set }
    
    /// Font of the labels on the Y axis.
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    var yAxisLabelFont: Font { get set }
    
    /// Text Colour for the labels on the Y axis.
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    var yAxisLabelColour: Color { get set }
    
    /// Number Of Labels on Y Axis.
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    var yAxisNumberOfLabels: Int { get set }
    
    /// Option to add custom Strings to Y axis rather than auto generated numbers.
    @available(*, deprecated, message: "Moved to view \".yAxisLabels\"")
    var yAxisLabelType: YAxisLabelType { get set }
    
    /// Style of the vertical lines breaking up the chart.
    @available(*, deprecated, message: "Moved to view \".xAxisGrid\"")
    var xAxisGridStyle: GridStyle { get set }
    
    /// Style of the horizontal lines breaking up the chart.
    @available(*, deprecated, message: "Moved to view \".yAxisGrid\"")
    var yAxisGridStyle: GridStyle { get set }
    
    /// Colour of the x axis border.
    @available(*, deprecated, message: "Moved to view \".axisBorder\"")
    var xAxisBorderColour: Color? { get set }
    /// Colour of the y axis border.
    @available(*, deprecated, message: "Moved to view \".axisBorder\"")
    var yAxisBorderColour: Color? { get set }
    
    /// Label to display next to the chart giving info about the axis.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var xAxisTitle: String? { get set }
    
    /// Font of the x axis title.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var xAxisTitleFont: Font { get set }
    
    /// Colour of the x axis title.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var xAxisTitleColour: Color { get set }

    /// Label to display next to the chart giving info about the axis.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var yAxisTitle: String? { get set }
    
    /// Font of the y axis title.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var yAxisTitleFont: Font { get set }
    
    /// Font of the y axis title.
    @available(*, deprecated, message: "Moved to view \".axisTitle\"")
    var yAxisTitleColour: Color { get set }
    
    /// Where to start drawing the line chart from. Zero, data set minium or custom.
    @available(*, deprecated, message: "Moved in the main chart data model")
    var baseline: Baseline { get set }
    
    /// Where to finish drawing the chart from. Data set maximum or custom.
    @available(*, deprecated, message: "Moved in the main chart data model")
    var topLine: Topline { get set }
    
}
