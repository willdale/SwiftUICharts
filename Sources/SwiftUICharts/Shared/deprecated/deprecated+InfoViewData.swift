//
//  deprecated+InfoViewData.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Data model to pass view information internally for the `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
 */
@available(*, deprecated, message: "Distributed to be more focused")
public struct InfoViewData<DP: CTDataPointBaseProtocol> {
    
    /**
     Is there currently input (touch or click) on the chart.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Moved to chart data")
    public var isTouchCurrent: Bool = false
    
    /**
     Closest data points to input.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Please use \"Combine\" instead.")
    var touchOverlayInfo: [DP] = []
    
    /**
     Set specifier of data point readout.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Please use number formatters instead.")
    var touchSpecifier: String = "%.0f"
    
    /**
     X axis posistion of the overlay box.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Touch data will be provided in when relevent")
    var touchLocation: CGPoint = .zero
    

    /**
     Size of the chart.
     
     Used to set the location of the data point readout View.
     
     Set from TouchOverlay via the relevant protocol.
     
     Used by `InfoBox`, `FloatingInfoBox` and `HeaderBox`.
     */
    @available(*, deprecated, message: "Sizing data will be passed at point of use.")
    var chartSize: CGRect  = .zero
    
    /**
     Option to display units before or after values.
     */
    @available(*, deprecated, message: "Please use number formatters")
    var touchUnit: TouchUnit = .none
}
