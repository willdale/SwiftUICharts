//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Main line shape
 */
internal struct LineShape: Shape {
           
    private let dataPoints  : [LineChartDataPoint]
    private let lineType    : LineType
    private let isFilled    : Bool
    
    private let minValue : Double
    private let range    : Double
    
    internal init(dataPoints: [LineChartDataPoint],
                  lineType  : LineType,
                  isFilled  : Bool,
                  minValue  : Double,
                  range     : Double
    ) {
        self.dataPoints = dataPoints
        self.lineType   = lineType
        self.isFilled   = isFilled
        self.minValue   = minValue
        self.range      = range
    }
  
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
        case .line:
            return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
        }
    }
}
