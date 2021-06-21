//
//  StackedBarDataSet.swift
//  
//
//  Created by Will Dale on 18/04/2021.
//

import SwiftUI

/**
 Main data set for a stacked bar chart.
 */
public struct StackedBarDataSets: CTMultiDataSetProtocol, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataSets: [StackedBarDataSet]
    
    /// Initialises a new data set for a Stacked Bar Chart.
    public init(dataSets: [StackedBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for stacked bars charts.
 */
public struct StackedBarDataSet: CTMultiBarChartDataSet {
    
    public let id: UUID = UUID()
    public var dataPoints: [StackedBarDataPoint]
    public var setTitle: String
    
    /// Initialises a new data set for a Stacked Bar Chart.
    public init(
        dataPoints: [StackedBarDataPoint],
        setTitle: String = ""
    ) {
        self.dataPoints = dataPoints
        self.setTitle = setTitle
    }
    
    public typealias ID = UUID
    public typealias DataPoint = StackedBarDataPoint
}
