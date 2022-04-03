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
    public var marketType: BarMarkerType
    
    public init(
        dataPoints: [RangedBarDataPoint],
        marketType: BarMarkerType = .full(colour: .primary, style: StrokeStyle())
    ) {
        self.dataPoints = dataPoints
        self.marketType = marketType
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
        self.marketType = .none
        self.legendTitle = legendTitle
    }
    
    @available(*, deprecated, message: "depricated")
    public var legendTitle: String = ""
}
