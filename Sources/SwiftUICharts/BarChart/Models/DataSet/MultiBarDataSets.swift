//
//  MultiBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

public struct GroupedBarDataSets: MultiDataSet {
    
    public let id       : UUID
    public var dataSets : [GroupedBarDataSet]
    
    /// Initialises a new data set for Multiline Line Chart.
    public init(dataSets: [GroupedBarDataSet]) {
        self.id       = UUID()
        self.dataSets = dataSets
    }
}


public struct GroupedBarDataSet: CTGroupedBarChartDataSet {

    public let id           : UUID
    public var dataPoints   : [GroupedBarChartDataPoint]
    public var legendTitle  : String
        
    /// Initialises a new data set for a Bar Chart.
    public init(dataPoints  : [GroupedBarChartDataPoint],
                legendTitle : String
    ) {
        self.id             = UUID()
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle        
    }

    public typealias ID        = UUID
    public typealias DataPoint = GroupedBarChartDataPoint
    public typealias Styling   = BarStyle
}