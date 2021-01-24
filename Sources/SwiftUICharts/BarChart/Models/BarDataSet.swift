//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public struct BarDataSet: SingleDataSet {

    public let id           : UUID
    public var dataPoints   : [ChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : BarStyle
    
    public init(dataPoints  : [ChartDataPoint],
                legendTitle : String,
                pointStyle  : PointStyle,
                style       : BarStyle
    ) {
        self.id             = UUID()
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }

    public typealias ID      = UUID
    public typealias Styling = BarStyle
}

public struct MultiBarDataSet: MultiDataSet {
    
    public let id       : UUID
    
    public var dataSets : [LineDataSet]
    
    public init(dataSets: [LineDataSet]) {
        self.id       = UUID()
        self.dataSets = dataSets
    }
}
