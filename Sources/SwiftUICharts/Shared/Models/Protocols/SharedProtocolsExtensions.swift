//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

extension ChartData where Set: SingleDataSet {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count > 2
    }
}

extension ChartData where Set: MultiDataSet {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: Bool = true
        dataSets.dataSets.forEach { dataSet in
            returnValue = dataSet.dataPoints.count > 2
        }
        return returnValue
    }
}
