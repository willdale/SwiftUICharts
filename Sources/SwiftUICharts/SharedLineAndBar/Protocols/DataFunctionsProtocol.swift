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
