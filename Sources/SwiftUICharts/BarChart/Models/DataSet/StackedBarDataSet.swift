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
public struct StackedBarDataSets: CTMultiDataSetProtocol {
    
    public let id       : UUID = UUID()
    public var dataSets : [StackedBarDataSet]
    
    /// Initialises a new data set for a Stacked Bar Chart.
    public init(dataSets: [StackedBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for stacked bars charts.
 
 # Example
 ```
 StackedBarDataSet(dataPoints: [
    MultiBarChartDataPoint(value: 10, group: GroupingData(title: "One", colour: .blue)),
    MultiBarChartDataPoint(value: 50, group: GroupingData(title: "Two", colour: .red))
 ])
 ```
 */
public struct StackedBarDataSet: CTMultiBarChartDataSet {

    public let id         : UUID = UUID()
    public var dataPoints : [MultiBarChartDataPoint]
    public var setTitle   : String
        
    /// Initialises a new data set for a Stacked Bar Chart.
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
