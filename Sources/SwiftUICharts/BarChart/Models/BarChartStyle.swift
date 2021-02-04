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
 
 # Example
 ```
 BarChartStyle(infoBoxPlacement: .header,
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
 BarChartStyle(infoBoxPlacement     : InfoBoxPlacement,
               xAxisGridStyle       : GridStyle,
               yAxisGridStyle       : GridStyle,
               xAxisLabelPosition   : XAxisLabelPosistion,
               xAxisLabelsFrom      : LabelsFrom,
               yAxisLabelPosition   : YAxisLabelPosistion,
               yAxisNumberOfLabels  : Int,
               globalAnimation      : Animation)
 ```
 
 ---
 
 # Also See
 - [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
 - [GridStyle](x-source-tag://GridStyle)
 - [XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
 - [LabelsFrom](x-source-tag://LabelsFrom)
 - [YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)
 
 # Conforms to
 - CTBarChartStyle
 - CTLineAndBarChartStyle
 - CTChartStyle
 
 - Tag: BarChartStyle
 */
public struct BarChartStyle: CTBarChartStyle {
        
    public var infoBoxPlacement     : InfoBoxPlacement
    public var globalAnimation      : Animation
        
    public var xAxisGridStyle       : GridStyle
    public var yAxisGridStyle       : GridStyle
    public var xAxisLabelPosition   : XAxisLabelPosistion
    public var xAxisLabelsFrom      : LabelsFrom
    public var yAxisLabelPosition   : YAxisLabelPosistion
    public var yAxisNumberOfLabels  : Int
    
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
