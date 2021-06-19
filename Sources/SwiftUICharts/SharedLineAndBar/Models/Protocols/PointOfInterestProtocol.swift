//
//  PointOfInterestProtocol.swift
//  
//
//  Created by Will Dale on 11/06/2021.
//

import SwiftUI

public protocol PointOfInterestProtocol {
    /**
     A type representing a Shape for displaying a line
     as a POI.
     */
    associatedtype MarkerShape: Shape
    
    /**
     Displays a line marking a Point Of Interest.
     
     In standard charts this will return a horizontal line.
     In horizontal charts this will return a vertical line.
     
     - Parameters:
        - value: Value of of the POI.
        - range: Difference between the highest and lowest values in the data set.
        - minValue: Lowest value in the data set.
     - Returns: A line shape at a specified point.
     */
    func poiMarker(value: Double, range: Double, minValue: Double) -> MarkerShape
    
    /**
     A type representing a View for displaying a label
     as a POI in an axis.
     */
    associatedtype LabelAxis: View
    /**
     Displays a label and box that mark a Point Of Interest
     in an axis.
     
     In standard charts this will display leading or trailing.
     In horizontal charts this will display bottom or top.
     */
    func poiLabelAxis(markerValue: Double, specifier: String, labelFont: Font, labelColour: Color, labelBackground: Color, lineColour: Color) -> LabelAxis
    
    /**
     Sets the position of the POI Label when it's over
     one of the axes.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiValueLabelPositionAxis(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint
    
    /**
     Sets the position of the POI Label when it's in
     the center of the view.
     
     - Parameters:
        - frame: Size of the chart.
        - markerValue: Value of the POI marker.
        - minValue: Lowest value in the data set.
        - range: Difference between the highest and lowest values in the data set.
     - Returns: Position of label.
     */
    func poiValueLabelPositionCenter(frame: CGRect, markerValue: Double, minValue: Double, range: Double) -> CGPoint
    
}
