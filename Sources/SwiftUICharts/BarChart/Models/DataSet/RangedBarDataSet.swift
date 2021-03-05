//
//  RangedBarDataSet.swift
//  
//
//  Created by Will Dale on 05/03/2021.
//

import SwiftUI

public struct RangedBarDataSet : CTRangedBarChartDataSet {
    
    public var id: UUID = UUID()
    public var dataPoints   : [RangedBarDataPoint]
    public var legendTitle  : String
    
    /// Initialises a new data set for standard Bar Charts.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: label for the data in legend.
    public init(dataPoints  : [RangedBarDataPoint],
                legendTitle : String = ""
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
    }
    
    
    public typealias ID        = UUID
    public typealias DataPoint = RangedBarDataPoint
}
