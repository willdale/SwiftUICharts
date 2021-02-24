//
//  LineAndBarProtocolsExtentions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import Foundation

extension LineAndBarChartData where Set: SingleDataSet {
    public var range : Double {
        return DataFunctions.dataSetRange(from: dataSets)
    }
    public var minValue : Double {
        return DataFunctions.dataSetMinValue(from: dataSets)
    }
    public var maxValue : Double {
        return DataFunctions.dataSetMaxValue(from: dataSets)
    }
    public var average  : Double {
        return DataFunctions.dataSetAverage(from: dataSets)
    }
}

extension LineAndBarChartData where Set: MultiDataSet {
    public var range : Double {
        return DataFunctions.multiDataSetRange(from: dataSets)
    }
    public var minValue : Double {
        return DataFunctions.multiDataSetMinValue(from: dataSets)
    }
    public var maxValue : Double {
        return DataFunctions.multiDataSetMaxValue(from: dataSets)
    }
    public var average  : Double {
        return DataFunctions.multiDataSetAverage(from: dataSets)
    }
}

extension LineAndBarChartData where Self: LineChartData {
    public var range : Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.dataSetMaxValue(from: dataSets) - min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.dataSetMaxValue(from: dataSets)
        }
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
}
extension LineAndBarChartData where Self: MultiLineChartData {
    public var range : Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.multiDataSetMaxValue(from: dataSets) - min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.multiDataSetMaxValue(from: dataSets)
        }
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
}
