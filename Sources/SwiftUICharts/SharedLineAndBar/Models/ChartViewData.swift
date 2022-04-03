//
//  ChartViewData.swift
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

public struct XAxisViewData {
    /**
     If the chart has labels on the X
     axis, the Y axis needs a different layout
     */
    var hasXAxisLabels: Bool = false
    
    /**
     The hieght of X Axis Title if it is there.
     
     Needed to set the position of the Y Axis labels.
     */
    var xAxisTitleHeight: CGFloat = 0
    
    /**
     The hieght of X Axis labels if they are there.
     
     Needed to set the position of the Y Axis labels.
     */
    var xAxisLabelHeights: [CGFloat] = []
    
    /**
     Width of the x axis title label once
     it has been rotated.
     
     Needed for calculating other parts
     of the layout system.
     */
    var xAxisLabelWidths: [CGFloat] = []
}

public struct YAxisViewData {
    /**
     If the chart has labels on the Y axis,
     the X axis needs a different layout.
     */
    var hasYAxisLabels: Bool = false
    
    /**
     Specifier for the values in the y axis labels.
     
     This gets passed in from the view modifier.
     */
    @available(*, deprecated, message: "Please use Number Formatter in the views instead")
    var yAxisSpecifier: String = "%.0f"
    
    /// Optional number formatter for the y axis labels when they are `.numeric`.
    @available(*, deprecated, message: "Number formatter is now in the view")
    var yAxisNumberFormatter: NumberFormatter? = nil
    
    /**
     Width of the y axis title label once
     it has been rotated.
     
     Needed for calculating other parts
     of the layout system.
     */
    var yAxisTitleWidth: CGFloat = 0

    var yAxisTitleHeight: CGFloat = 0
    
    var yAxisLabelWidths: [CGFloat] = []
    var yAxisLabelHeights: [CGFloat] = []
}
