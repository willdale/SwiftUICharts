//
//  MultiPieDataPoint.swift
//  
//
//  Created by Will Dale on 22/02/2021.
//

import SwiftUI

public struct MultiPieDataPoint: CTMultiPieChartDataPoint {
    
    public var id: UUID = UUID()
    // CTPieDataPoint
    public var startAngle  : Double = 0
    public var amount      : Double = 0
    // CTChartDataPoint
    public var value            : Double
    public var pointDescription : String?
    public var date             : Date?
    // CTMultiPieChartDataPoint
    public var layerDataPoints  : [MultiPieDataPoint]?
    
    public var colour           : Color
    
    public init(value           : Double,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red,
                layerDataPoints : [MultiPieDataPoint]? = nil
    ) {
        self.value              = value
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
        self.layerDataPoints    = layerDataPoints
    }
}
