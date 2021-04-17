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
                        description: "One One",
                        group: GroupingData(title: "One", colour: .blue))
 ```
 */
public struct MultiBarChartDataPoint: CTMultiBarDataPoint {
    
    public let id          : UUID = UUID()
    public var value       : Double
    public var xAxisLabel  : String? = nil
    public var description : String?
    public var date        : Date?
    public var group       : GroupingData
    
    public var legendTag : String = ""
    
    public init(value       : Double,
                description : String?   = nil,
                date        : Date?     = nil,
                group       : GroupingData
    ) {
        self.value       = value
        self.description = description
        self.date        = date
        self.group       = group
    }
    
    public typealias ID = UUID
}

