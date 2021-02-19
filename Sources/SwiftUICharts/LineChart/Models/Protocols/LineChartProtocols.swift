//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `LineAndBarChartData` specifically for Line Charts.
 
 # Reference
 [See LineAndBarChartData](x-source-tag://LineAndBarChartData)
 
 `LineAndBarChartData` conforms to [ChartData](x-source-tag://ChartData)
 
 - Tag: LineChartDataProtocol
 */
public protocol LineChartDataProtocol: LineAndBarChartData {

    associatedtype Marker : View
    /**
     Whether it is a normal or filled line.
     */
    var isFilled    : Bool { get set}
    
    /**
     Returns the position to place the indicator on the line
     based on the users touch or pointer input.
     
     - Parameters:
        - rect: Frame of the path.
        - dataSet: Dataset used to draw the chart.
        - touchLocation: Location of the touch or pointer input.
     - Returns: The position to place the indicator.
     */
    func getIndicatorLocation(rect: CGRect, dataPoints: [LineChartDataPoint], touchLocation: CGPoint, lineType: LineType) -> CGPoint
    
    func getSinglePoint(touchLocation: CGPoint, chartSize: GeometryProxy, dataSet: LineDataSet) -> CGPoint
    
    func markerSubView(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: GeometryProxy) -> Marker
}



// MARK: - Style
/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Line Charts.
 
 - Tag: CTLineChartStyle
 */
public protocol CTLineChartStyle : CTLineAndBarChartStyle {
    /**
     Where to start drawing the line chart from. Zero or data set minium.
     
     [See Baseline](x-source-tag://Baseline)
     */
    var baseline: Baseline { get set }

}



// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Line Charts.
 
 # Reference
 [See SingleDataSet](x-source-tag://SingleDataSet)
 
 - Tag: CTLineChartDataSet
 */
public protocol CTLineChartDataSet: SingleDataSet {
    associatedtype Styling   : CTColourStyle
    
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
    
    /**
     Sets the style for the Data Set (as opposed to Chart Data Style).
     */
    var style       : Styling { get set }
    /**
     Sets the look of the markers over the data points.
     
     The markers are layed out when the `ViewModifier` [.pointMarkers](x-source-tag://PointMarkers)
     is applied.
     */
    var pointStyle  : PointStyle { get set }
}
