//
//  DataFunctionsProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Foundation

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

public protocol GetDataProtocol {
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
}
