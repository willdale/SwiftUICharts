//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct LineShape<CD>: Shape where CD: LineChartDataProtocol {
           
    @ObservedObject var chartData: CD
    private let dataPoints  : [LineChartDataPoint]
    private let lineType    : LineType
    private let isFilled    : Bool
    
    private let minValue : Double
    private let range    : Double
    
    
    internal init(chartData : CD,
                  dataPoints: [LineChartDataPoint],
                  lineType  : LineType,
                  isFilled  : Bool,
                  minValue  : Double,
                  range     : Double
    ) {
        self.chartData  = chartData
        self.dataPoints = dataPoints
        self.lineType   = lineType
        self.isFilled   = isFilled
        self.minValue   = minValue
        self.range      = range
    }
  
    internal func path(in rect: CGRect) -> Path {
        
        switch lineType {
        case .curvedLine:
            return chartData.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
        case .line:
            return chartData.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled)
        }
    }
}
