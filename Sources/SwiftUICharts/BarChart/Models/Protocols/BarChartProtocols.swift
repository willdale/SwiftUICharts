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
 A protocol to extend functionality of `CTLineBarDataPoint` specifically for standard Bar Charts.
 */
public protocol CTBarDataPoint: CTLineBarDataPoint {}

/**
 A protocol to extend functionality of `CTLineBarDataPoint` specifically for standard Bar Charts.
 */
public protocol CTStandardBarDataPoint: CTBarDataPoint, CTColourStyle {}

/**
 A protocol to extend functionality of `CTLineBarDataPoint` specifically for multi part Bar Charts.
 i.e: Grouped or Stacked
 */
public protocol CTMultiBarDataPoint: CTBarDataPoint {
    
    /**
     For grouping data points together so they can be drawn in the correct groupings.
     */
    var group : GroupingData { get set }
    
}
