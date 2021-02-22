//
//  PieDataSet.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

public struct PieDataSet: SingleDataSet {

    public var id           : UUID = UUID()
    public var dataPoints   : [PieChartDataPoint]
    public var legendTitle  : String
    public var style        : PieSegmentStyle
    
    public init(dataPoints  : [PieChartDataPoint],
                legendTitle : String,
                style       : PieSegmentStyle
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.style          = style
    }

    public typealias Styling = PieSegmentStyle
    public typealias DataPoint = PieChartDataPoint
}


