//
//  ExtraLineShape.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

internal struct ExtraLineShape<DataPoint>: Shape where DataPoint: CTStandardDataPointProtocol & Ignorable {
    
    private let dataPoints: [DataPoint]
    private let lineType: LineType
    private let lineSpacing: ExtraLineStyle.SpacingType
    private let range: Double
    private let minValue: Double
    
    internal init(
        dataPoints: [DataPoint],
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        range: Double,
        minValue: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch (lineType, lineSpacing) {
        case (.curvedLine, .line):
            return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .line):
            return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.curvedLine, .bar):
            return Path.curvedLineBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .bar):
            return Path.straightLineBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}
