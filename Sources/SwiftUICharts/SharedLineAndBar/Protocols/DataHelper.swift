//
//  DataHelper.swift
//  
//
//  Created by Will Dale on 23/01/2022.
//

import Foundation

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

extension DataHelper where Self: CTChartData,
                           SetType: DataFunctionsProtocol {
    public var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch baseline {
            case .minimumValue:
                _lowestValue = dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(dataSets.minValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch topLine {
            case .maximumValue:
                _highestValue = dataSets.maxValue()
            case .maximum(of: let value):
                _highestValue = max(dataSets.maxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    
    public var minValue: Double {
        get {
            switch baseline {
            case .minimumValue:
                return dataSets.minValue()
            case .minimumWithMaximum(of: let value):
                return min(dataSets.minValue(), value)
            case .zero:
                return 0
            }
        }
    }
    
    public var maxValue: Double {
        get {
            switch topLine {
            case .maximumValue:
                return dataSets.maxValue()
            case .maximum(of: let value):
                return max(dataSets.maxValue(), value)
            }
        }
    }
    
    public var average: Double {
        return dataSets.average()
    }
}
