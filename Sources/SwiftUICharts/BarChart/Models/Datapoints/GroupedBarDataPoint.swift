//
//  GroupedBarDataPoint.swift
//  SwiftUICharts
//
//  Created by Ataias Pereira Reis on 18/04/21.
//

import SwiftUI

/**
 Data for a single grouped bar chart data point.

 # Example
 ```
 GroupedBarDataPoint(
    value: 10,
    description: "One One",
    group: GroupingData(
        title: "One",
        colour: .blue
    )
 )
 ```
 */
public struct GroupedBarDataPoint: CTMultiBarDataPoint {

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

