//
//  GroupedBarDataPoint.swift
//  SwiftUICharts
//
//  Created by Ataias Pereira Reis on 18/04/21.
//

import SwiftUI

/**
 Data for a single grouped bar chart data point.
 */
public struct GroupedBarDataPoint: CTMultiBarDataPoint {
    
    public let id: UUID = UUID()
    public var value: Double
    public var xAxisLabel: String? = nil
    public var description: String?
    public var date: Date?
    public var group: GroupingData
    
    public var _legendTag: String = ""
    
    /// Data model for a single data point with colour info for use with a grouped bar chart.
    /// - Parameters:
    ///   - value: Value of the data point.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - group: Group data informs the data models how the data point are linked.
    public init(
        value: Double,
        description: String? = nil,
        date: Date? = nil,
        group: GroupingData
    ) {
        self.value = value
        self.description = description
        self.date = date
        self.group = group
    }
    
    public typealias ID = UUID
}
