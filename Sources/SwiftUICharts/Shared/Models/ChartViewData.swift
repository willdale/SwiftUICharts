//
//  ChartViewData.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import Foundation

/// Data model to pass view information internally so the layout can configure its self.
internal struct ChartViewData {
    
    /// Pass the type of chart being used to view modifiers.
    var chartType   : ChartType = .line
    
    /// If the chart has labels on the X axis, the Y axis needs a different layout
    var hasXAxisLabels      : Bool = false
    
    /// If the chart has labels on the Y axis, the X axis needs a different layout
    var hasYAxisLabels      : Bool = false
    
    /**
    Is there currently input (touch or click) on the chart
    
    Set from TouchOverlay
    
    Used by TitleBox
     */
    var isTouchCurrent      : Bool = false
    /**
     Closest data point to input
     
     Set from TouchOverlay
     
     Used by TitleBox
     */
    var touchOverlayInfo    : ChartDataPoint?
    /**
     Set specifier of data point readout
     
     Set from TouchOverlay
     
     Used by TitleBox
     */
    var touchSpecifier      : String = "%.0f"
    
}
