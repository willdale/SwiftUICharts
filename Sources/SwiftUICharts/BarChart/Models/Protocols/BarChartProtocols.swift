//
//  BarChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `CTLineBarChartDataProtocol` specifically for Bar Charts.
 */
public protocol CTBarChartDataProtocol: CTLineBarChartDataProtocol {
    
    associatedtype BarStyle : CTBarStyle
    /**
     Overall styling for the bars
     */
    var barStyle : BarStyle { get set }
}

/**
 A protocol to extend functionality of `CTBarChartDataProtocol` specifically for Multi Part Bar Charts.
 */
public protocol CTMultiBarChartDataProtocol: CTBarChartDataProtocol {
    
    /**
     Grouping data to inform the chart about the relationship between the datapoints.
     */
    var groups : [GroupingData] { get set }
}





// MARK: - Style
/**
 A protocol to extend functionality of `CTLineBarChartStyle` specifically for  Bar Charts.
 */
public protocol CTBarChartStyle: CTLineBarChartStyle {}

public protocol CTBarStyle: Hashable {
    /// How much of the available width to use. 0...1
    var barWidth    : CGFloat { get set }
    /// Corner radius of the bar shape.
    var cornerRadius: CornerRadius { get set }
    /// Where to get the colour data from.
    var colourFrom  : ColourFrom { get set }
    /// Drawing style of the fill.
    var fillColour : ColourStyle { get set }
}






// MARK: - DataSet
/**
 A protocol to extend functionality of `CTSingleDataSetProtocol` specifically for Standard Bar Charts.
 */
public protocol CTStandardBarChartDataSet: CTSingleDataSetProtocol {
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
}

/**
 A protocol to extend functionality of `CTSingleDataSetProtocol` specifically for Multi Part Bar Charts.
 */
public protocol CTMultiBarChartDataSet: CTSingleDataSetProtocol  {}










// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for standard Bar Charts.
 */
public protocol CTBarDataPoint: CTLineBarDataPointProtocol {}

/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for standard Bar Charts.
 */
public protocol CTStandardBarDataPoint: CTBarDataPoint {
    /// Drawing style of the range fill.
    var fillColour : ColourStyle { get set }
}

/**
 A protocol to extend functionality of `CTLineBarDataPointProtocol` specifically for multi part Bar Charts.
 i.e: Grouped or Stacked
 */
public protocol CTMultiBarDataPoint: CTBarDataPoint {
    
    /**
     For grouping data points together so they can be drawn in the correct groupings.
     */
    var group : GroupingData { get set }
    
}
