//
//  LineAndBarProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `ChartData` specifically for Line and Bar Charts.
 */
public protocol LineAndBarChartData : ChartData {

    associatedtype CTLineAndBarCS : CTLineAndBarChartStyle
    associatedtype XLabels  : View
    
    /**
     Array of strings for the labels on the X Axis instead of the labels in the data points.

     To control where the labels should come from.
     Set [LabelsFrom](x-source-tag://LabelsFrom) in [ChartStyle](x-source-tag://CTChartStyle).
    */
    var xAxisLabels: [String]? { get set }
    
    /**
     Data model to hold data about the Views layout.

     This informs some `ViewModifiers` whether the chart has X and/or Y
     axis labels so they can configure thier layouts appropriately.
     */
    var viewData: ChartViewData { get set }
    
    
    /**
     Data model conatining the style data for the chart.
     
     # Reference
     [CTChartStyle](x-source-tag://CTChartStyle)
     */
    var chartStyle: CTLineAndBarCS { get set }
        
    /**
     Labels to display on the Y axis
     
     The labels are generated based on the range between the lowest number in the
     data set (or 0) and highest number in the data set.
     
     - Returns: Array of evenly spaced numbers.
     */
    func getYLabels() -> [Double]
    
    /**
     Returns the difference between the highest and lowest numbers in the data set or data sets.
     */
    func getRange() -> Double
    
    /**
     Returns the lowest value in the data set or data sets.
     */
    func getMinValue() -> Double
    
    /**
     Returns the highest value in the data set or data sets
     */
    func getMaxValue() -> Double
    
    /**
     Returns the average value from the data set or data sets.
     */
    func getAverage() -> Double
    
    /**
     Displays a view for the labels on the X Axis.
     */
    func getXAxisLabels() -> XLabels
}


// MARK: - Style

public protocol MarkerType {}

/**
 A protocol to extend functionality of `CTChartStyle` specifically for  Line and Bar Charts.
 */
public protocol CTLineAndBarChartStyle: CTChartStyle {
    
    associatedtype Mark : MarkerType
    
    /**
     Where the marker lines come from to meet at a specified point.
     */
    var markerType : Mark { get set }
    
    /**
     Style of the vertical lines breaking up the chart
     
     [See GridStyle](x-source-tag://GridStyle)
     */
    var xAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Top or Bottom
     
     [See XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
     */
    var xAxisLabelPosition: XAxisLabelPosistion { get set }
    
    /**
     Text Colour for the labels on the X axis.
     
     */
    var xAxisLabelColour: Color { get set }
    
    /**
     Where the label data come from. DataPoint or ChartData
     
     [See LabelsFrom](x-source-tag://LabelsFrom)
     */
    var xAxisLabelsFrom: LabelsFrom { get set }
    
    
    /**
     Style of the horizontal lines breaking up the chart.
     
     [See GridStyle](x-source-tag://GridStyle)
     */
    var yAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Leading or Trailing
     
     [See YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)
     */
    var yAxisLabelPosition: YAxisLabelPosistion { get set }
    
    /**
     Text Colour for the labels on the Y axis.
     
     */
    var yAxisLabelColour: Color { get set }
    
    /**
     Number Of Labels on Y Axis
     */
    var yAxisNumberOfLabels: Int { get set }
    
}

// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTChartDataPoint` specifically for Line and Bar Charts.
 */
public protocol CTLineAndBarDataPoint: CTChartDataPoint {
    
    /**
     Data points label for the X axis.
     */
    var xAxisLabel       : String? { get set }
}
