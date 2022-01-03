//
//  DataFunctionsProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Foundation

/// Convenience functions for data sets
public protocol DataFunctionsProtocol {
    /**
     Returns the highest value in the data set.
     - Returns: Highest value in data set.
     */
    func maxValue() -> Double
    
    /**
     Returns the lowest value in the data set.
     - Returns: Lowest value in data set.
     */
    func minValue() -> Double
    
    /**
     Returns the average value from the data set.
     - Returns: Average of values in data set.
     */
    func average() -> Double
}

public protocol DataHelper {
    /**
     Returns the difference between the highest and lowest numbers in the data set or data sets.
     */
    var range: Double { get }
    
    /**
     Returns the lowest value in the data set or data sets.
     */
    var minValue: Double { get }
    
    /**
     Returns the highest value in the data set or data sets
     */
    var maxValue: Double { get }
    
    /**
     Returns the average value from the data set or data sets.
     */
    var average: Double { get }
    
    /// Where to start drawing the line chart from. Zero, data set minium or custom.
    var baseline: Baseline { get set }
    
    /// Where to finish drawing the chart from. Data set maximum or custom.
    var topLine: Topline { get set }
}
