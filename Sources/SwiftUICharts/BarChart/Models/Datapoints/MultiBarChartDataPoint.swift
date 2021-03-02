//
//  MultiBarChartDataPoint.swift
//  
//
//  Created by Will Dale on 19/02/2021.
//

import SwiftUI

/**
 Data for a single bar chart data point.
  
 # Example
 ```
 MultiBarChartDataPoint(value: 10,
                          xAxisLabel: "1.1",
                          pointLabel: "One One",
                          group: GroupingData(title: "One", colour: .blue))
 ```
 */
public struct MultiBarChartDataPoint: CTMultiBarDataPoint {
    
    public let id               : UUID = UUID()

    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?

    public var group     : GroupingData
    
    public init(value       : Double,
                xAxisLabel  : String?   = nil,
                pointLabel  : String?   = nil,
                date        : Date?     = nil,
                group       : GroupingData
    ) {
        self.value            = value
        self.xAxisLabel       = xAxisLabel
        self.pointDescription = pointLabel
        self.date             = date
        
        self.group            = group

    }
    public typealias ID = UUID
}

