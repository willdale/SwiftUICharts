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

    /// A type representing the chart style. -- `CTChartStyle`
    associatedtype CTLineAndBarCS : CTLineAndBarChartStyle
    /// A type representing opaque View
    associatedtype XLabels  : View
    
    /**
     Returns the difference between the highest and lowest numbers in the data set or data sets.
     */
    var range    : Double { get }
    
    /**
     Returns the lowest value in the data set or data sets.
     */
    var minValue : Double { get }
    
    /**
     Returns the highest value in the data set or data sets
     */
    var maxValue : Double { get }
    
    /**
     Returns the average value from the data set or data sets.
     */
    var average  : Double { get }
    
    /**
     Array of strings for the labels on the X Axis instead of the labels in the data points.
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
     Displays a view for the labels on the X Axis.
     */
    func getXAxisLabels() -> XLabels

}




// MARK: - Style
/**
 A protocol to get the correct touch overlay marker.
 */
public protocol MarkerType {}

/**
 A protocol to extend functionality of `CTChartStyle` specifically for  Line and Bar Charts.
 */
public protocol CTLineAndBarChartStyle: CTChartStyle {
    
    /// A type representing touch overlay marker type. -- `MarkerType`
    associatedtype Mark : MarkerType
    
    /**
     Where the marker lines come from to meet at a specified point.
     */
    var markerType : Mark { get set }
    
    /**
     Style of the vertical lines breaking up the chart.
     */
    var xAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Top or Bottom.
     */
    var xAxisLabelPosition: XAxisLabelPosistion { get set }
    
    /**
     Text Colour for the labels on the X axis.
     */
    var xAxisLabelColour: Color { get set }
    
    /**
     Where the label data come from. DataPoint or ChartData.
     */
    var xAxisLabelsFrom: LabelsFrom { get set }
    
    
    /**
     Style of the horizontal lines breaking up the chart.
     */
    var yAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Leading or Trailing.
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
    var xAxisLabel: String? { get set }
}
