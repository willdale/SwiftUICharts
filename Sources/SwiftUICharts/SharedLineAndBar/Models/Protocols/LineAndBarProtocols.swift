//
//  LineAndBarProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTChartData` specifically for Line and Bar Charts.
 */
public protocol CTLineBarChartDataProtocol: CTChartData where CTStyle: CTLineBarChartStyle {
    
    /**
     Array of strings for the labels on the X Axis instead of the labels in the data points.
     */
    var xAxisLabels: [String]? { get set }
    
    /**
     Array of strings for the labels on the Y Axis instead of the labels generated
     from data point values.
     */
    var yAxisLabels: [String]? { get set }
    
    /**
     Data model to hold data about the Views layout.
     
     This informs some `ViewModifiers` whether the chart has X and/or Y
     axis labels so they can configure thier layouts appropriately.
     */
    var viewData: ChartViewData { get set }
    
    
    
    
    /**
     A data model for the `ExtraLine` View Modifier
    */
    var extraLineData: ExtraLineData? { get set }
    
    /**
     A type representing a View for displaying second set of labels on the Y axis.
    */
    associatedtype ExtraYLabels: View
    
    /**
     View for displaying second set of labels on the Y axis.
    */
    func getExtraYAxisLabels() -> ExtraYLabels
    
    /**
     Get the relevant colour indicator for the y axis labels.
    */
    func getColour() -> ColourStyle
    
    
    
    
    
    /**
     A type representing a View for displaying labels on the X axis.
     */
    associatedtype XLabels: View
    /**
     Displays a view for the labels on the X Axis.
     */
    func getXAxisLabels() -> XLabels
    
    /**
     A type representing a View for displaying labels on the X axis.
     */
    associatedtype YLabels: View
    
    /**
     Displays a view for the labels on the Y Axis.
     */
    func getYAxisLabels() -> YLabels
    
    
    /**
     Sets the data point info box location while keeping it within the parent view.
     
     - Parameters:
        - touchLocation: Location the user has pressed.
        - boxFrame: The size of the point info box.
        - chartSize: The size of the chart view as the parent view.
     */
    func setBoxLocation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat
}



// MARK: - Style
/**
 A protocol to get the correct touch overlay marker.
 */
public protocol MarkerType {}

/**
 A protocol to extend functionality of `CTChartStyle` specifically for  Line and Bar Charts.
 */
public protocol CTLineBarChartStyle: CTChartStyle {
    
    /// A type representing touch overlay marker type. -- `MarkerType`
    associatedtype Mark: MarkerType
    
    /**
     Where the marker lines come from to meet at a specified point.
     */
    var markerType: Mark { get set }
    
    /**
     Style of the vertical lines breaking up the chart.
     */
    var xAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Top or Bottom.
     */
    var xAxisLabelPosition: XAxisLabelPosistion { get set }
    
    /**
     Font of the labels on the X axis.
     */
    var xAxisLabelFont: Font { get set }
    
    /**
     Text Colour for the labels on the X axis.
     */
    var xAxisLabelColour: Color { get set }
    
    /**
     Where the label data come from. DataPoint or ChartData.
     */
    var xAxisLabelsFrom: LabelsFrom { get set }
    
    /**
     Label to display next to the chart giving info about the axis.
     */
    var xAxisTitle: String? { get set }
    
    /**
     Font of the x axis title.
     */
    var xAxisTitleFont: Font { get set }
    
    /**
     Colour of the x axis title.
     */
    var xAxisTitleColour: Color { get set }
    
    /**
     Colour of the x axis border.
     */
    var xAxisBorderColour: Color? { get set }
    
    /**
     Style of the horizontal lines breaking up the chart.
     */
    var yAxisGridStyle: GridStyle { get set }
    
    /**
     Location of the X axis labels - Leading or Trailing.
     */
    var yAxisLabelPosition: YAxisLabelPosistion { get set }
    
    /**
     Font of the labels on the Y axis.
     */
    var yAxisLabelFont: Font { get set }
    
    /**
     Text Colour for the labels on the Y axis.
     */
    var yAxisLabelColour: Color { get set }
    
    /**
     Number Of Labels on Y Axis.
     */
    var yAxisNumberOfLabels: Int { get set }
    
    /**
     Option to add custom Strings to Y axis rather than
     auto generated numbers.
     */
    var yAxisLabelType: YAxisLabelType { get set }
    
    /**
     Label to display next to the chart giving info about the axis.
     */
    var yAxisTitle: String? { get set }
    
    /**
     Font of the y axis title.
     */
    var yAxisTitleFont: Font { get set }
    
    /**
     Font of the y axis title.
     */
    var yAxisTitleColour: Color { get set }
    
    /**
     Colour of the y axis border.
     */
    var yAxisBorderColour: Color? { get set }
    
    /**
     Where to start drawing the line chart from. Zero, data set minium or custom.
     */
    var baseline: Baseline { get set }
    
    /**
     Where to finish drawing the chart from. Data set maximum or custom.
     */
    var topLine: Topline { get set }
    
}

// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTStandardDataPointProtocol` specifically for Line and Bar Charts.
 */
public protocol CTLineBarDataPointProtocol: CTDataPointBaseProtocol {
    
    /**
     Data points label for the X axis.
     */
    var xAxisLabel: String? { get set }
}

extension CTLineBarDataPointProtocol {
    
    /**
     Unwarpped xAxisLabel
     */
    var wrappedXAxisLabel: String {
        self.xAxisLabel ?? ""
    }
}
