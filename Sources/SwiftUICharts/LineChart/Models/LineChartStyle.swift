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
 
 # Example
 ```
 LineChartStyle(infoBoxPlacement: .header,
                xAxisGridStyle  : GridStyle(numberOfLines: 7,
                                            lineColour   : .gray,
                                            lineWidth    : 1,
                                            dash         : [8],
                                            dashPhase    : 0),
                yAxisGridStyle  : GridStyle(numberOfLines: 7,
                                            lineColour   : .gray,
                                            lineWidth    : 1,
                                            dash         : [8],
                                            dashPhase    : 0),
                xAxisLabelPosition  : .bottom,
                xAxisLabelsFrom     : .dataPoint,
                yAxisLabelPosition  : .leading,
                yAxisNumberOfLabels : 5,
                baseline            : .minimumValue,
                globalAnimation     : .linear(duration: 1))
 ```

 # Options
 ```
 LineChartStyle(infoBoxPlacement    : InfoBoxPlacement,
                xAxisGridStyle      : GridStyle,
                yAxisGridStyle      : GridStyle,
                xAxisLabelPosition  : XAxisLabelPosistion,
                xAxisLabelsFrom     : LabelsFrom,
                yAxisLabelPosition  : YAxisLabelPosistion,
                yAxisNumberOfLabels : Int,
                baseline            : Baseline,
                globalAnimation     : Animation)
 ```
 
 ---
 
 # Also See
 - [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
 - [GridStyle](x-source-tag://GridStyle)
 - [XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
 - [LabelsFrom](x-source-tag://LabelsFrom)
 - [YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)
 
 # Conforms to
 - CTLineChartStyle
 - CTLineAndBarChartStyle
 - CTChartStyle
 
 - Tag: LineChartStyle
 */
public struct LineChartStyle: CTLineChartStyle {
    
    public var infoBoxPlacement     : InfoBoxPlacement
    public var globalAnimation      : Animation
    
    public var xAxisGridStyle       : GridStyle
    public var yAxisGridStyle       : GridStyle
    public var xAxisLabelPosition   : XAxisLabelPosistion
    public var xAxisLabelsFrom      : LabelsFrom
    public var yAxisLabelPosition   : YAxisLabelPosistion
    public var yAxisNumberOfLabels  : Int
    
    public var baseline             : Baseline
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing
    ///   - yAxisNumberOfLabel: Number Of Labels on Y Axis
    ///   - baseline: Whether the chart is drawn from baseline of zero or the minimum datapoint value.
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement    : InfoBoxPlacement      = .floating,
                xAxisGridStyle      : GridStyle             = GridStyle(),
                yAxisGridStyle      : GridStyle             = GridStyle(),
                xAxisLabelPosition  : XAxisLabelPosistion   = .bottom,
                xAxisLabelsFrom     : LabelsFrom            = .dataPoint,
                yAxisLabelPosition  : YAxisLabelPosistion   = .leading,
                yAxisNumberOfLabels : Int                   = 10,
                baseline            : Baseline              = .minimumValue,
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement   = infoBoxPlacement
        self.xAxisGridStyle     = xAxisGridStyle
        self.yAxisGridStyle     = yAxisGridStyle

        self.xAxisLabelPosition  = xAxisLabelPosition
        self.xAxisLabelsFrom     = xAxisLabelsFrom
        self.yAxisLabelPosition  = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        
        self.baseline            = baseline
        
        self.globalAnimation     = globalAnimation
    }
}
