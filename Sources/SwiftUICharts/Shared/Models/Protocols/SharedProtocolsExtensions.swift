//
//  SharedProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

extension CTChartData where Set: CTSingleDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        return dataSets.dataPoints.count > 2
    }
}

extension CTChartData where Set: CTMultiDataSetProtocol {
    public func isGreaterThanTwo() -> Bool {
        var returnValue: Bool = true
        dataSets.dataSets.forEach { dataSet in
            returnValue = dataSet.dataPoints.count > 2
        }
        return returnValue
    }
}
