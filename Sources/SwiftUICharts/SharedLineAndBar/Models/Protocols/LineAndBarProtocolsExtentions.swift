//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

// MARK: - Single Data Set
extension CTLineBarChartDataProtocol where Set: CTSingleDataSetProtocol {
    public var range : Double {
        
        var _lowestValue  : Double
        var _highestValue : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            _lowestValue = DataFunctions.dataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            _lowestValue = min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
            _lowestValue = 0
        }
        
        switch self.chartStyle.topLine {
        case .maximumValue:
            _highestValue = DataFunctions.dataSetMaxValue(from: dataSets)
        case .maximum(of: let value):
            _highestValue = max(DataFunctions.dataSetMaxValue(from: dataSets), value)
        }

        return _highestValue - _lowestValue
    }
    
    public var minValue : Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
            return 0
        }
    }
    
    public var maxValue : Double {
        switch self.chartStyle.topLine {
        case .maximumValue:
            return DataFunctions.dataSetMaxValue(from: dataSets)
        case .maximum(of: let value):
            return max(DataFunctions.dataSetMaxValue(from: dataSets), value)
        }
    }
    
    public var average  : Double {
        return DataFunctions.dataSetAverage(from: dataSets)
    }
}


// MARK: - Multi Data Set
extension CTLineBarChartDataProtocol where Set: CTMultiDataSetProtocol {
    public var range : Double {
        
        var _lowestValue  : Double
        var _highestValue : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            _lowestValue = DataFunctions.multiDataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            _lowestValue = min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            _lowestValue = 0
        }
        
        switch self.chartStyle.topLine {
        case .maximumValue:
            _highestValue = DataFunctions.multiDataSetMaxValue(from: dataSets)
        case .maximum(of: let value):
            _highestValue = max(DataFunctions.multiDataSetMaxValue(from: dataSets), value)
        }

        return _highestValue - _lowestValue
    }
    public var minValue : Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return 0
        }
    }
    
    public var maxValue : Double {
        switch self.chartStyle.topLine {
        case .maximumValue:
            return DataFunctions.multiDataSetMaxValue(from: dataSets)
        case .maximum(of: let value):
            return max(DataFunctions.multiDataSetMaxValue(from: dataSets), value)
        }
    }
    
    public var average  : Double {
        return DataFunctions.multiDataSetAverage(from: dataSets)
    }
}

// MARK: - Y Labels

extension CTLineBarChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double = self.range
        let minValue    : Double = self.minValue
        let range       : Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels-1)
        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels-1 {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
}
