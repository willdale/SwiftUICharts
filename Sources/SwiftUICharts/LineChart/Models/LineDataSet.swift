//
//  LineDataSet.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public struct LineDataSet: SingleDataSet {

    public let id           : UUID
    public var dataPoints   : [LineChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : Styling
    
    public init(dataPoints  : [LineChartDataPoint],
                legendTitle : String,
                pointStyle  : PointStyle = PointStyle(),
                style       : LineDataSet.Styling
    ) {
        self.id             = UUID()
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }
    
    public typealias ID      = UUID
    public typealias Styling = LineStyle
}



public struct MultiLineDataSet: MultiDataSet {
    
    public let id       : UUID
    
    public var dataSets : [LineDataSet]
    
    public init(dataSets: [LineDataSet]) {
        self.id       = UUID()
        self.dataSets = dataSets
    }
        
}
