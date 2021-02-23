//
//  BarChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

// MARK: - Chart Data
/**
 A protocol to extend functionality of `LineAndBarChartData` specifically for Bar Charts.
 */
public protocol BarChartDataProtocol: LineAndBarChartData {
        
    /**
     Overall styling for the bars
     */
    var barStyle : BarStyle { get set }
}

/**
 A protocol to extend functionality of `BarChartDataProtocol` specifically for Multi Part Bar Charts.
 */
public protocol MultiBarChartDataProtocol: BarChartDataProtocol {
    
    /**
     Grouping data to inform the chart about the relationship between the datapoints.
     */
    var groups : [GroupingData] { get set }
}





// MARK: - Style
/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Bar Charts.
 */
public protocol CTBarChartStyle: CTLineAndBarChartStyle {}








// MARK: - DataSet
/**
 A protocol to extend functionality of `SingleDataSet` specifically for Standard Bar Charts.
 */
public protocol CTStandardBarChartDataSet: SingleDataSet {
    /**
     Label to display in the legend.
     */
    var legendTitle : String { get set }
}

/**
 A protocol to extend functionality of `SingleDataSet` specifically for Multi Part Bar Charts.
 */
public protocol CTMultiBarChartDataSet: SingleDataSet  {}










// MARK: - DataPoints
/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for standard Bar Charts.
 */
public protocol CTBarDataPoint: CTLineAndBarDataPoint {}

/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for standard Bar Charts.
 */
public protocol CTStandardBarDataPoint: CTBarDataPoint, CTColourStyle {}

/**
 A protocol to extend functionality of `CTLineAndBarDataPoint` specifically for multi part Bar Charts.
 i.e: Grouped or Stacked
 */
public protocol CTMultiBarDataPoint: CTBarDataPoint {
    
    var group : GroupingData { get set }
    
}
