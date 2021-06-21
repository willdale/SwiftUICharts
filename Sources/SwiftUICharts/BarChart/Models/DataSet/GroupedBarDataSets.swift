//
//  GroupedBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Main data set for a grouped bar charts.
 */
public struct GroupedBarDataSets: CTMultiDataSetProtocol, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataSets: [GroupedBarDataSet]
    
    /// Initialises a new data set for Grouped Bar Chart.
    public init(dataSets: [GroupedBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for grouped bars charts.
 */
public struct GroupedBarDataSet: CTMultiBarChartDataSet {
    
    public let id: UUID = UUID()
    public var dataPoints: [GroupedBarDataPoint]
    public var setTitle: String
    
    /// Initialises a new data set for a Bar Chart.
    public init(
        dataPoints: [GroupedBarDataPoint],
        setTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.setTitle = setTitle
    }
    
    public typealias ID = UUID
    public typealias DataPoint = GroupedBarDataPoint
}
