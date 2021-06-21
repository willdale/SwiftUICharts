//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a bar chart.
 */
public struct BarDataSet: CTStandardBarChartDataSet, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataPoints: [BarChartDataPoint]
    public var legendTitle: String
    
    /// Initialises a new data set for standard Bar Charts.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    public init(
        dataPoints: [BarChartDataPoint],
        legendTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
    }
    
    public typealias ID = UUID
    public typealias DataPoint = BarChartDataPoint
}
