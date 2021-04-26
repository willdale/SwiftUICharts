//
//  ChartViewData.swift
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

/**
 Data model to pass view information internally so the layout can configure its self.
 */
public struct ChartViewData {
    
    /**
     If the chart has labels on the X axis, the Y axis needs a different layout
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
     If the chart has labels on the Y axis, the X axis needs a different layout
     */
    var hasYAxisLabels: Bool = false
}
