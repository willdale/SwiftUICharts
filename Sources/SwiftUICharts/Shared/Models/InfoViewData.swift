//
//  InfoViewData.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/// Data model to pass view information internally so the layout can configure its self.
///
///  # Reference
///  [CTChartDataPoint](x-source-tag://CTChartDataPoint)
///
/// - Tag: InfoViewData
public struct InfoViewData<DP: CTChartDataPoint> {
    
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
    var touchOverlayInfo    : [DP] = []
    
    /**
     Set specifier of data point readout
     
     Set from TouchOverlay
     
     Used by TitleBox
     */
    var touchSpecifier      : String = "%.0f"

    var positionX    : CGFloat = 0
    var frame       : CGRect = .zero
    var yAxisLabelWidth: CGFloat = 0
}
