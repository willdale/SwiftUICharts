//
//  InfoViewData.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data model to pass view information internally for the `InfoBox` and `HeaderBox`.
 */
public struct InfoViewData<DP: CTChartDataPoint> {
    
    /**
    Is there currently input (touch or click) on the chart.
    
    Set from TouchOverlay via the relevant protocol.
    
    Used by `HeaderBox` and `InfoBox`.
     */
    var isTouchCurrent      : Bool = false
    
    /**
     Closest data points to input.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `HeaderBox` and `InfoBox`.
     */
    var touchOverlayInfo    : [DP] = []
    
    /**
     Set specifier of data point readout.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `HeaderBox` and `InfoBox`.
     */
    var touchSpecifier      : String = "%.0f"

    /**
     X axis posistion of the overlay box.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `HeaderBox` and `InfoBox`.
     */
    var positionX           : CGFloat = 0
    
    /**
     Current width of the `Info Box`.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `HeaderBox` and `InfoBox`.
     */
    var frame               : CGRect  = .zero
    
    /**
     Current width of the `YAxisLabels`
     
     Needed line up the touch overlay to compensate for
     the loss of width.
     */
    var yAxisLabelWidth     : CGFloat = 0
}
