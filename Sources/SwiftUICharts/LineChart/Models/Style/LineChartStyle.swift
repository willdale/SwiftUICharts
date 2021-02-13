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
 LineChartStyle(infoBoxPlacement    : .header,
                xAxisGridStyle      : GridStyle(numberOfLines: 7,
                                                lineColour   : .gray,
                                                lineWidth    : 1,
                                                dash         : [8],
                                                dashPhase    : 0),
                xAxisLabelPosition  : .bottom,
                xAxisLabelsFrom     : .dataPoint,
                yAxisGridStyle      : GridStyle(numberOfLines: 7,
                                                lineColour   : .gray,
                                                lineWidth    : 1,
                                                dash         : [8],
                                                dashPhase    : 0),
                yAxisLabelPosition  : .leading,
                yAxisNumberOfLabels : 5,
                baseline            : .minimumValue,
                globalAnimation     : .linear(duration: 1))
 ```

 # Options
 ```
 LineChartStyle(infoBoxPlacement: InfoBoxPlacement,
                infoBoxValueColour: Color,
                infoBoxDescriptionColor: Color,
                xAxisGridStyle: GridStyle,
                xAxisLabelPosition: XAxisLabelPosistion,
                xAxisLabelColour: Color,
                xAxisLabelsFrom: LabelsFrom,
                yAxisGridStyle: GridStyle,
                yAxisLabelPosition: YAxisLabelPosistion,
                yAxisLabelColour: Color,
                yAxisNumberOfLabels: Int,
                baseline: Baseline,
                globalAnimation: Animation)
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
    
    public var infoBoxPlacement        : InfoBoxPlacement
    public var infoBoxValueColour      : Color
    public var infoBoxDescriptionColor : Color
        
    public var xAxisGridStyle       : GridStyle
    public var xAxisLabelPosition   : XAxisLabelPosistion
    public var xAxisLabelColour     : Color
    public var xAxisLabelsFrom      : LabelsFrom
    
    public var yAxisGridStyle       : GridStyle
    public var yAxisLabelPosition   : YAxisLabelPosistion
    public var yAxisLabelColour     : Color
    public var yAxisNumberOfLabels  : Int
    
    public var baseline             : Baseline
    public var globalAnimation      : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColor: Colour of the description part of the touch info.
    ///
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom.
    ///   - xAxisLabelColour: Text Colour for the labels on the X axis.
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels.
    ///
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing.
    ///   - yAxisLabelColour: Text Colour for the labels on the Y axis.
    ///   - yAxisNumberOfLabel: Number Of Labels on Y Axis.
    ///
    ///   - baseline: Whether the chart is drawn from baseline of zero or the minimum datapoint value.
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColor : Color             = Color.primary,
                
                xAxisGridStyle      : GridStyle             = GridStyle(),
                xAxisLabelPosition  : XAxisLabelPosistion   = .bottom,
                xAxisLabelColour    : Color                 = Color.primary,
                xAxisLabelsFrom     : LabelsFrom            = .dataPoint,
                
                yAxisGridStyle      : GridStyle             = GridStyle(),
                yAxisLabelPosition  : YAxisLabelPosistion   = .leading,
                yAxisLabelColour    : Color                 = Color.primary,
                yAxisNumberOfLabels : Int                   = 10,

                baseline            : Baseline              = .minimumValue,
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement        = infoBoxPlacement
        self.infoBoxValueColour      = infoBoxValueColour
        self.infoBoxDescriptionColor = infoBoxDescriptionColor
        
        self.xAxisGridStyle      = xAxisGridStyle
        self.xAxisLabelPosition  = xAxisLabelPosition
        self.xAxisLabelsFrom     = xAxisLabelsFrom
        self.xAxisLabelColour    = xAxisLabelColour
        
        self.yAxisGridStyle      = yAxisGridStyle
        self.yAxisLabelPosition  = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        self.yAxisLabelColour    = yAxisLabelColour
        
        self.baseline            = baseline
        self.globalAnimation     = globalAnimation
    }
}
