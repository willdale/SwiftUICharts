//
//  PieDataSet.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 Data set for a pie chart.
 */
public struct PieDataSet: CTSingleDataSetProtocol {
    
    public var id: UUID = UUID()
    public var dataPoints: [PieChartDataPoint]
    public var markerType: PieMarkerType
    
    /// Initialises a new data set for a standard pie chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    public init(
        dataPoints: [PieChartDataPoint],
        markerType: PieMarkerType = .none
    ) {
        self.dataPoints = dataPoints
        self.markerType = markerType
    }
    
    public typealias ID = UUID
    public typealias DataPoint = PieChartDataPoint
    
    @available(*, deprecated, message: "depricated")
    public var legendTitle: String = ""
    
    /// Initialises a new data set for a standard pie chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    @available(*, deprecated, message: "\"legendTitle\" has been depricated")
    public init(
        dataPoints: [PieChartDataPoint],
        legendTitle: String
    ) {
        self.dataPoints = dataPoints
        self.markerType = .none
        self.legendTitle = legendTitle
    }
}
