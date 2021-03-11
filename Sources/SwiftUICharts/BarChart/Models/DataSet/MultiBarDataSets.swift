//
//  MultiBarDataSet.swift
//  
//
//  Created by Will Dale on 04/02/2021.
//

import SwiftUI

/**
 Main data set for a multi part bar charts.
 
 # Example
 ```
 let data = MultiBarDataSets(dataSets: [
     MultiBarDataSet(dataPoints: [
         MultiBarChartDataPoint(value: 10, group: GroupingData(title: "One", colour: .blue))
    ]),
     MultiBarDataSet(dataPoints: [
         MultiBarChartDataPoint(value: 20, group: GroupingData(title: "One", colour: .blue))
    ])
 ])
 ```
 */
public struct MultiBarDataSets: CTMultiDataSetProtocol {
    
    public let id       : UUID = UUID()
    public var dataSets : [MultiBarDataSet]
    
    /// Initialises a new data set for Multiline Line Chart.
    public init(dataSets: [MultiBarDataSet]) {
        self.dataSets = dataSets
    }
}

/**
 Individual data sets for multi part bars charts.
 
 # Example
 ```
 MultiBarDataSet(dataPoints: [
     MultiBarChartDataPoint(value: 10, group: GroupingData(title: "One", colour: .blue)),
     MultiBarChartDataPoint(value: 50, group: GroupingData(title: "Two", colour: .red))
 ])
 ```
 */
public struct MultiBarDataSet: CTMultiBarChartDataSet {

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
