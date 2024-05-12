//
//  RangedBarDataSet.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

/**
 Data set for ranged bar charts.
 */
public struct RangedBarDataSet: CTRangedBarChartDataSet, DataFunctionsProtocol {
    
    public var id: UUID = UUID()
    public var dataPoints: [RangedBarDataPoint]
    public var markerType: BarMarkerType
    
    public init(
        dataPoints: [RangedBarDataPoint],
        markerType: BarMarkerType = .full(colour: .primary, style: StrokeStyle())
    ) {
        self.dataPoints = dataPoints
        self.markerType = markerType
    }
    
    public func maxValue() -> Double {
        self.dataPoints
            .map(\.upperValue)
            .max() ?? 0
    }
    public func minValue() -> Double {
        self.dataPoints
            .map(\.lowerValue)
            .min() ?? 0
    }
    public func average() -> Double {
        self.dataPoints
            .reduce(0) { $0 + ($1.upperValue - $1.lowerValue) }
            .divide(by: Double(self.dataPoints.count))
    }
    
    public typealias ID = UUID
    public typealias DataPoint = RangedBarDataPoint
    
    /// Initialises a new data set for ranged bar chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    @available(*, deprecated, message: "\"legendTitle\" has been depricated")
    public init(
        dataPoints: [RangedBarDataPoint],
        legendTitle: String
    ) {
        self.dataPoints = dataPoints
        self.markerType = .none
        self.legendTitle = legendTitle
    }
    
    @available(*, deprecated, message: "depricated")
    public var legendTitle: String = ""
}
