//
//  LineAndBarEnums.swift
//  
//
//  Created by Will Dale on 08/02/2021.
//

import Foundation

// MARK: - XAxisLabels
/**
Location of the X axis labels
 ```
 case top
 case bottom
 ```
 
 - Tag: XAxisLabelPosistion
 */
public enum XAxisLabelPosistion {
    case top
    case bottom
}
/**
 Where the label data come from.
 
 xAxisLabel comes from  ChartData --> DataPoint model.
 
 xAxisLabels comes from ChartData --> xAxisLabels
 ```
 case dataPoint // ChartData --> DataPoint --> xAxisLabel
 case chartData // ChartData --> xAxisLabels
 ```
 
 - Tag: LabelsFrom
 */
public enum LabelsFrom {
    /// ChartData --> DataPoint --> xAxisLabel
    case dataPoint
    /// ChartData --> xAxisLabels
    case chartData
}

// MARK: - YAxisLabels
/**
Location of the Y axis labels
 ```
 case leading
 case trailing
 ```
 
 - Tag: YAxisLabelPosistion
 */
public enum YAxisLabelPosistion {
    case leading
    case trailing
}

/**
 Option to display the markers' value inline with the marker..
 
 ```
 case none // No label.
 case yAxis(specifier: String) // Places the label in the yAxis labels.
 case center(specifier: String) // Places the label in the center of chart.
 ```
 
 - Tag: DisplayValue
 */
public enum DisplayValue {
    /// No label.
    case none
    /// Places the label in the yAxis labels.
    case yAxis(specifier: String)
    /// Places the label in the center of chart.
    case center(specifier: String)
}
