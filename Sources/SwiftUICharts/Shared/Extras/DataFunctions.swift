//
//  DataFunctions.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import Foundation

struct DataFunctions {
    
    // MARK: - Just DataPoints
    /// Get the highest value from dataPoints array.
    /// - Returns: Highest value.
    static func maxValue(dataPoints: [ChartDataPoint]) -> Double {
        return dataPoints.max { $0.value < $1.value }?.value ?? 0
    }
    /// Get the Lowest value from dataPoints array.
    /// - Returns: Lowest value.
    static func minValue(dataPoints: [ChartDataPoint]) -> Double {
        return dataPoints.min { $0.value < $1.value }?.value ?? 0
    }
    /// Get the average of all the dataPoints.
    /// - Returns: Average.
    static func average(dataPoints: [ChartDataPoint]) -> Double {
        let sum = dataPoints.reduce(0) { $0 + $1.value }
        return sum / Double(dataPoints.count)
    }
    /// Get the difference between the hightest and lowest value in the dataPoints array.
    /// - Returns: Difference.
    static func range(dataPoints: [ChartDataPoint]) -> Double {
        let maxValue = dataPoints.max { $0.value < $1.value }?.value ?? 0
        let minValue = dataPoints.min { $0.value < $1.value }?.value ?? 0
        
        /*
         Adding 0.001 stops the following error if there is no variation in value of the dataPoints
         2021-01-07 13:59:50.490962+0000 LineChart[4519:237208] [Unknown process name] Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
         */
        return (maxValue - minValue) + 0.001
    }
    
    // MARK: - Single Data Set
    static func dataSetMaxValue<T:SingleDataSet>(from dataSets: [T]) -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            setHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.max { $0 < $1 } ?? 0
    }
    
    static func dataSetMinValue<T:SingleDataSet>(from dataSets: [T]) -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            setHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.min { $0 < $1 } ?? 0
    }
    
    static func dataSetAverage<T:SingleDataSet>(from dataSets: [T]) -> Double {
        var setHolder : [Double] = []
        for set in dataSets {
            let sum = set.dataPoints.reduce(0) { $0 + $1.value }
            setHolder.append(sum / Double(set.dataPoints.count))
        }
        let sum = setHolder.reduce(0) { $0 + $1 }
        return sum / Double(setHolder.count)
    }
    
    static func dataSetRange<T:SingleDataSet>(from dataSets: [T]) -> Double {
        var setMaxHolder : [Double] = []
        for set in dataSets {
            setMaxHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        let maxValue = setMaxHolder.max { $0 < $1 } ?? 0
        
        var setMinHolder : [Double] = []
        for set in dataSets {
            setMinHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        let minValue = setMinHolder.min { $0 < $1 } ?? 0
        
        /*
         Adding 0.001 stops the following error if there is no variation in value of the dataPoints
         2021-01-07 13:59:50.490962+0000 LineChart[4519:237208] [Unknown process name] Error: this application, or a library it uses, has passed an invalid numeric value (NaN, or not-a-number) to CoreGraphics API and this value is being ignored. Please fix this problem.
         */
        return (maxValue - minValue) + 0.001
    }
    
    // MARK: - Multi Data Sets
    static func multiDataSetMaxValue<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            setHolder.append(set.dataPoints.max { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.max { $0 < $1 } ?? 0
    }
    
    static func multiDataSetMinValue<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            setHolder.append(set.dataPoints.min { $0.value < $1.value }?.value ?? 0)
        }
        return setHolder.min { $0 < $1 } ?? 0
    }

    static func multiDataSetAverage<T:MultiDataSet>(from dataSets: T) -> Double {
        var setHolder : [Double] = []
        for set in dataSets.dataSets {
            let sum = set.dataPoints.reduce(0) { $0 + $1.value }
            setHolder.append(sum / Double(set.dataPoints.count))
        }
        let sum = setHolder.reduce(0) { $0 + $1 }
        return sum / Double(setHolder.count)
    }

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
