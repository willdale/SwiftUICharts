//
//  GroupedBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

// MARK: - Grouped
/**
 Main data set for a grouped bar charts.
 */
public struct GroupedBarDataSets: CTMultiDataSetProtocol {
    
    public let id       : UUID = UUID()
    public var dataSets : [GroupedBarDataSet]
    
    /// Initialises a new data set for Multiline Line Chart.
    public init(dataSets: [GroupedBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for grouped bars charts.
 
 # Example
 ```
 GroupedBarDataSet(dataPoints: [
    GroupedBarChartDataPoint(value: 10, group: GroupingData(title: "One", colour: .blue)),
    GroupedBarChartDataPoint(value: 50, group: GroupingData(title: "Two", colour: .red))
 ])
 ```
 */
public struct GroupedBarDataSet: CTMultiBarChartDataSet {

    public let id         : UUID = UUID()
    public var dataPoints : [MultiBarChartDataPoint]
    public var setTitle   : String
        
    /// Initialises a new data set for a Bar Chart.
    public init(dataPoints: [MultiBarChartDataPoint],
                setTitle  : String = ""
    ) {
        self.dataPoints = dataPoints
        self.setTitle   = setTitle
    }

    public typealias ID        = UUID
    public typealias DataPoint = MultiBarChartDataPoint
    public typealias Styling   = BarStyle
}

