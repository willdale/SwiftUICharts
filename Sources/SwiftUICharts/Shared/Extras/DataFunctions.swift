//
//  DataFunctions.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import Foundation

/**
 A collection of functions for getting infomation about the data sets.
*/
 struct DataFunctions {
    
    // MARK: - Single Data Set
    /**
     Returns the highest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Highest value in data set.
     */
    static func dataSetMaxValue<T:SingleDataSet>(from dataSet: T) -> Double {
        return dataSet.dataPoints.max { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the lowest value in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Lowest value in data set.
     */
    static func dataSetMinValue<T:SingleDataSet>(from dataSet: T) -> Double {
        return dataSet.dataPoints.min { $0.value < $1.value }?.value ?? 0
    }
    
    /**
     Returns the average value from the data set.
     - Parameter dataSet: Target data set.
     - Returns: Average of values in data set.
     */
    static func dataSetAverage<T:SingleDataSet>(from dataSet: T) -> Double {
        let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
        return sum / Double(dataSet.dataPoints.count)
    }
    
    /**
     Returns the difference between the highest and lowest numbers in the data set.
     - Parameter dataSet: Target data set.
     - Returns: Difference between the highest and lowest values in data set.
     */
    static func dataSetRange<T:SingleDataSet>(from dataSet: T) -> Double {
        let maxValue = dataSet.dataPoints.max { $0.value < $1.value }?.value ?? 0
        let minValue = dataSet.dataPoints.min { $0.value < $1.value }?.value ?? 0
        
        /*
         Adding 0.001 stops the following error if there is no variation in value of the dataPoints
         2021-01-07 13:59:50.490962+0000 LineChart[4519:237208] [Unknown process name] Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
         */
        return (maxValue - minValue) + 0.001
    }
    
    
    // MARK: - Multi Data Sets
    /**
     Returns the highest value in the data sets
     - Parameter dataSet: Target data sets.
     - Returns: Highest value in data sets.
     */
    static func multiDataSetMaxValue<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            setHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.max { $0 < $1 } ?? 0
    }
    
    /**
     Returns the lowest value in the data sets.
     - Parameter dataSet: Target data sets.
     - Returns: Lowest value in data sets.
     */
    static func multiDataSetMinValue<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            setHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.min { $0 < $1 } ?? 0
    }
    
    /**
     Returns the average value from the data sets.
     - Parameter dataSet: Target data sets.
     - Returns: Average of values in data sets.
     */
    static func multiDataSetAverage<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            let sum = set.dataPoints.reduce(0) { $0 + $1.value }
            setHolder.append(sum / Double(set.dataPoints.count))
        }
        let sum = setHolder.reduce(0) { $0 + $1 }
        return sum / Double(setHolder.count)
    }
    
    /**
     Returns the difference between the highest and lowest numbers in the data sets.
     - Parameter dataSet: Target data sets.
     - Returns: Difference between the highest and lowest values in data sets.
     */
    static func multiDataSetRange<T:MultiDataSet>(from dataSets: T) -> Double {
        var setMaxHolder : [Double] = []
        for set in dataSets.dataSets {
            setMaxHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        let maxValue = setMaxHolder.max { $0 < $1 } ?? 0
        
        var setMinHolder : [Double] = []
        for set in dataSets.dataSets {
            setMinHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        let minValue = setMinHolder.min { $0 < $1 } ?? 0
        
        /*
         Adding 0.001 stops the following error if there is no variation in value of the dataPoints
         2021-01-07 13:59:50.490962+0000 LineChart[4519:237208] [Unknown process name] Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
         */
        return (maxValue - minValue) + 0.001
    }
}
