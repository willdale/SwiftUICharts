//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

extension LineAndBarChartData {
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
}
extension LineAndBarChartData where Set: SingleDataSet {
    public func getRange() -> Double {
        DataFunctions.dataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.dataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.dataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.dataSetAverage(from: dataSets)
    }
}
extension LineAndBarChartData where Set: MultiDataSet {
    public func getRange() -> Double {
        DataFunctions.multiDataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.multiDataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.multiDataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.multiDataSetAverage(from: dataSets)
    }
}
