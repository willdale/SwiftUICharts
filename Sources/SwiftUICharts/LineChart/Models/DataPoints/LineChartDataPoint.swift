//
//  LineChartDataPoint.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for a single data point.
 */
public struct LineChartDataPoint: CTStandardLineDataPoint, Ignorable {
    
    public let id: UUID = UUID()
    public var value: Double
    public var xAxisLabel: String?
    public var description: String?
    public var pointColour: PointColour?
    
    public var ignore: Bool
    
    public var _legendTag: String = ""
        
    /// Data model for a single data point with colour for use with a line chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - xAxisLabel: Label that can be shown on the X axis.
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - pointColour: Colour of the point markers.
    public init(
        value: Double,
        xAxisLabel: String? = nil,
        description: String? = nil,
        pointColour: PointColour? = nil,
        ignore: Bool = false
    ) {
        self.value = value
        self.xAxisLabel = xAxisLabel
        self.description = description
        self.pointColour = pointColour
        self.ignore = ignore
    }
}
