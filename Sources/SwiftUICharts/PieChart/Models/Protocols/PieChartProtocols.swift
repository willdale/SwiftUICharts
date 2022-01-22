//
//  PieChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

public protocol PieChartType {}

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTChartData` specifically for Pie and Doughnut Charts.
 */
public protocol CTPieDoughnutChartDataProtocol: CTChartData {}

/**
 A protocol to extend functionality of `CTPieDoughnutChartDataProtocol` specifically for Pie Charts.
 */
public protocol CTPieChartDataProtocol: CTPieDoughnutChartDataProtocol {}

/**
 A protocol to extend functionality of `CTPieDoughnutChartDataProtocol` specifically for  Doughnut Charts.
 */
public protocol CTDoughnutChartDataProtocol: CTPieDoughnutChartDataProtocol {}


// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTStandardDataPointProtocol` specifically for Pie and Doughnut Charts.
 */
public protocol CTPieDataPoint: CTStandardDataPointProtocol, CTnotRanged {
    
    /**
     Colour of the segment
     */
    var colour: Color { get set }
    
    /**
     Where the data point should start drawing from
     based on where the prvious one finished.
     
     In radians.
     */
    var startAngle: Double { get set }
    
    /**
     The data points value in radians.
     */
    var amount: Double { get set }
    
    /**
     Option to add overlays on top of the segment.
     */
    var label: OverlayType { get set }
}
