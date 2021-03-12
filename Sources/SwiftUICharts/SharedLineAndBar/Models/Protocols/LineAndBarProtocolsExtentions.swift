//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Data Set
extension CTLineBarChartDataProtocol {
    public var range : Double {
        
        var _lowestValue  : Double
        var _highestValue : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            _lowestValue = self.dataSets.minValue()
        case .minimumWithMaximum(of: let value):
            _lowestValue = min(self.dataSets.minValue(), value)
        case .zero:
            _lowestValue = 0
        }
        
        switch self.chartStyle.topLine {
        case .maximumValue:
            _highestValue = self.dataSets.maxValue()
        case .maximum(of: let value):
            _highestValue = max(self.dataSets.maxValue(), value)
        }

        return (_highestValue - _lowestValue) + 0.001
    }
    
    public var minValue : Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return self.dataSets.minValue()
        case .minimumWithMaximum(of: let value):
            return min(self.dataSets.minValue(), value)
        case .zero:
            return 0
        }
    }
    
    public var maxValue : Double {
        switch self.chartStyle.topLine {
        case .maximumValue:
            return self.dataSets.maxValue()
        case .maximum(of: let value):
            return max(self.dataSets.maxValue(), value)
        }
    }
    
    public var average  : Double {
        return self.dataSets.average()
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
