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
        
    public var infoBoxPlacement        : InfoBoxPlacement
    public var infoBoxValueColour      : Color
    public var infoBoxDescriptionColor : Color
    public var markerType              : MarkerType
    
    public var xAxisGridStyle       : GridStyle
    public var xAxisLabelPosition   : XAxisLabelPosistion
    public var xAxisLabelColour     : Color
    public var xAxisLabelsFrom      : LabelsFrom
    
    public var yAxisGridStyle       : GridStyle
    public var yAxisLabelPosition   : YAxisLabelPosistion
    public var yAxisLabelColour     : Color
    public var yAxisNumberOfLabels  : Int
    
    public var globalAnimation      : Animation
    
    /// Model for controlling the overall aesthetic of the chart.
    /// - Parameters:
    ///   - infoBoxPlacement: Placement of the information box that appears on touch input.
    ///   - infoBoxValueColour: Colour of the value part of the touch info.
    ///   - infoBoxDescriptionColor: Colour of the description part of the touch info.
    ///   
    ///   - markerType: Where the marker lines come from to meet at a specified point.
    ///
    ///   - xAxisGridStyle: Style of the vertical lines breaking up the chart.
    ///   - xAxisLabelPosition: Location of the X axis labels - Top or Bottom.
    ///   - xAxisLabelsFrom: Where the label data come from. DataPoint or xAxisLabels.
    ///   - xAxisLabelColour: Text Colour for the labels on the X axis.
    ///
    ///   - yAxisGridStyle: Style of the horizontal lines breaking up the chart.
    ///   - yAxisLabelPosition: Location of the X axis labels - Leading or Trailing.
    ///   - yAxisNumberOfLabel: Number Of Labels on Y Axis.
    ///   - yAxisLabelColour: Text Colour for the labels on the Y axis.
    ///
    ///   - globalAnimation: Gobal control of animations.
    public init(infoBoxPlacement        : InfoBoxPlacement  = .floating,
                infoBoxValueColour      : Color             = Color.primary,
                infoBoxDescriptionColor : Color             = Color.primary,
                markerType              : MarkerType        = .full(attachment: .line),
                
                xAxisGridStyle      : GridStyle             = GridStyle(),
                xAxisLabelPosition  : XAxisLabelPosistion   = .bottom,
                xAxisLabelColour    : Color                 = Color.primary,
                xAxisLabelsFrom     : LabelsFrom            = .dataPoint,
                
                yAxisGridStyle      : GridStyle             = GridStyle(),
                yAxisLabelPosition  : YAxisLabelPosistion   = .leading,
                yAxisLabelColour    : Color                 = Color.primary,
                yAxisNumberOfLabels : Int                   = 10,
                
                globalAnimation     : Animation             = Animation.linear(duration: 1)
    ) {
        self.infoBoxPlacement        = infoBoxPlacement
        self.infoBoxValueColour      = infoBoxValueColour
        self.infoBoxDescriptionColor = infoBoxDescriptionColor
        self.markerType              = markerType
        
        self.xAxisGridStyle      = xAxisGridStyle
        self.xAxisLabelPosition  = xAxisLabelPosition
        self.xAxisLabelColour    = xAxisLabelColour
        self.xAxisLabelsFrom     = xAxisLabelsFrom
        
        self.yAxisGridStyle      = yAxisGridStyle
        self.yAxisLabelPosition  = yAxisLabelPosition
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        self.yAxisLabelColour    = yAxisLabelColour
        
        self.globalAnimation     = globalAnimation
    }
}
