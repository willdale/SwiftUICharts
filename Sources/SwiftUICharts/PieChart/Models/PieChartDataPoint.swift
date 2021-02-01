//
//  PieChartDataPoint.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

public struct PieChartDataPoint: CTPieDataPoint {
    
    public var id               : UUID = UUID()
    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    
    public var colour           : Color
    
    var startAngle  : Double = 0
    var amount      : Double = 0
    
    public init(value           : Double,
                xAxisLabel      : String?   = nil,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red
    ) {
        self.value              = value
        self.xAxisLabel         = xAxisLabel
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
    }
}
