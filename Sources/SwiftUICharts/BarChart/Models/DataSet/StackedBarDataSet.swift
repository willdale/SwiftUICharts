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
    public var markerType: BarMarkerType
    
    /// Initialises a new data set for a Stacked Bar Chart.
    public init(
        dataSets: [StackedBarDataSet],
        markerType: BarMarkerType = .full(colour: .primary, style: StrokeStyle())
    ) {
        self.dataSets = dataSets
        self.markerType = markerType
    }
    
    public var dataWidth: Int {
        return dataSets.count
    }
    
    public var dataLabels: [String] {
        return dataSets.map(\.setTitle)
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
    
    var totalSetValue: Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
    }
    
    public typealias ID = UUID
    public typealias DataPoint = StackedBarDataPoint
}
