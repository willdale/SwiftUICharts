//
//  ArrayOperations.swift
//  
//
//  Created by Will Dale on 12/05/2024.
//

import Foundation

@inlinable
public func calculateRange(baseline: Baseline, topLine: Topline, minValue: Double, maxValue: Double) -> Double {
    let highestValue: Double = switch topLine {
    case .maximumValue: maxValue
    case .maximum(of: let value): max(maxValue, value)
    }
    
    let lowestValue: Double = switch baseline {
    case .minimumValue: minValue
    case .minimumWithMaximum(of: let value): min(minValue, value)
    case .zero: 0
    }
    return (highestValue - lowestValue)
}

@inlinable
public func minValue(baseline: Baseline, minValue: Double) -> Double {
   return switch baseline {
    case .minimumValue: minValue
    case .minimumWithMaximum(of: let value): min(minValue, value)
    case .zero: 0
    }
}

@inlinable
public func maxValue(topLine: Topline, maxValue: Double) -> Double {
    return switch topLine {
    case .maximumValue: maxValue
    case .maximum(of: let value): max(maxValue, value)
    }
}

// MARK: Single Data Set

@inlinable
public func maxValue<T>(dataPoints: borrowing [T]) -> Double where T: SingleDataValue {
    dataPoints.map(\.value).max() ?? 0
}

@inlinable
public func minValue<T>(dataPoints: borrowing [T]) -> Double where T: SingleDataValue {
    dataPoints.map(\.value).min() ?? 0
}

@inlinable
public func minAndMaxValue<T>(dataPoints: borrowing [T]) -> (min: Double, max: Double) where T: SingleDataValue {
    let sorted = dataPoints.map(\.value).sorted()
    let min = sorted.first ?? 0
    let max = sorted.last ?? 0
    return (min: min, max: max)
}

@inlinable
public func average<T>(dataPoints: borrowing [T]) -> Double where T: SingleDataValue {
    dataPoints.map(\.value).reduce(0, +).divide(by: Double(dataPoints.count))
}

// MARK: Multi Data Set

@inlinable
public func maxValue<T>(dataPoints: [[T]]) -> Double where T: SingleDataValue {
    return dataPoints.joined().map(\.value).max() ?? 0
}

@inlinable
public func minValue<T>(dataPoints: [[T]]) -> Double where T: SingleDataValue {
    return dataPoints.joined().map(\.value).min() ?? 0
}

@inlinable
public func minAndMaxValue<T>(dataPoints: [[T]]) -> (min: Double, max: Double) where T: SingleDataValue {
    let sorted = dataPoints.joined().map(\.value).sorted()
    let min = sorted.first ?? 0
    let max = sorted.last ?? 0
    return (min: min, max: max)
}

@inlinable
public func average<T>(dataPoints: [[T]]) -> Double where T: SingleDataValue {
    let joinedDataPoint = dataPoints.joined().map(\.value)
    let sum = joinedDataPoint.reduce(0, +)
    let average = sum / CGFloat(joinedDataPoint.count)
    return average
}


// MARK: Ranged Data Set

@inlinable
public func maxValue<T>(dataPoints: borrowing [T]) -> Double where T: RangedDataValue {
    dataPoints.map(\.upperValue).max() ?? 0
}

@inlinable
public func minValue<T>(dataPoints: borrowing [T]) -> Double where T: RangedDataValue {
    dataPoints.map(\.lowerValue).min() ?? 0
}

@inlinable
public func average<T>(dataPoints: borrowing [T]) -> Double where T: RangedDataValue {
    dataPoints.reduce(0) { $0 + ($1.upperValue - $1.lowerValue) }.divide(by: Double(dataPoints.count))
}


@inlinable
public func minAndMaxValue<T>(dataPoints: borrowing [T]) -> (min: Double, max: Double) where T: RangedDataValue {
    let min = dataPoints.map(\.lowerValue).min() ?? 0
    let max = dataPoints.map(\.upperValue).max() ?? 0
    return (min: min, max: max)
}

//extension CTMultiDataSetProtocol where Self == StackedBarDataSets {
//    /**
//     Returns the highest sum value in the data sets
//     
//     - Note:
//     This differs from other charts, as Stacked Bar Charts
//     need to consider the sum value for each data set, instead of the
//     max value of a data point.
//     
//     - Returns: Highest sum value in data sets.
//     */
//    public func maxValue() -> Double {
//        self.dataSets
//            .map {
//                $0.dataPoints
//                    .map(\.value)
//                    .reduce(0.0, +)
//            }
//            .max() ?? 0
//    }
//}
//extension CTMultiBarChartDataSet where Self == StackedBarDataSet {
//    /**
//     Returns the highest sum value in the data set.
//     
//     - Note:
//     This differs from other charts, as Stacked Bar Charts
//     need to consider the sum value for each data set, instead of the
//     max value of a data point.
//     
//     - Returns: Highest sum value in data set.
//     */
//    public func maxValue() -> Double {
//        self.dataPoints
//            .map(\.value)
//            .reduce(0, +)
//    }
//}
