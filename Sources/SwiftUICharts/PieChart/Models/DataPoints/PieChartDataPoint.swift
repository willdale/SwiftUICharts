//
//  PieChartDataPoint.swift
//  
//
//  Created by Will Dale on 01/02/2021.
//

import SwiftUI

/**
 Data for a single segement of a pie chart.
 */
public struct PieChartDataPoint: CTPieDataPoint {
    
    public var id: UUID = UUID()
    public var value: Double
    public var description: String?
    public var date: Date?
    public var colour: Color
    public var label: OverlayType
    public var startAngle: Double = 0
    public var amount: Double = 0
    public var legendTag: String = ""
    
    /// Data model for a single data point for a pie chart.
    /// - Parameters:
    ///   - value: Value of the data point
    ///   - description: A longer label that can be shown on touch input.
    ///   - date: Date of the data point if any data based calculations are required.
    ///   - colour: Colour of the segment.
    ///   - label: Option to add overlays on top of the segment.
    public init(
        value: Double,
        description: String? = nil,
        date: Date? = nil,
        colour: Color = Color.red,
        label: OverlayType = .none
    ) {
        self.value = value
        self.description = description
        self.date = date
        self.colour = colour
        self.label = label
    }
}

extension PieChartDataPoint {
    // Remove legend tag from compare
    public static func == (left: PieChartDataPoint, right: PieChartDataPoint) -> Bool {
        return (left.id == right.id) &&
            (left.amount == right.amount) &&
            (left.startAngle == right.startAngle) &&
            (left.value == right.value) &&
            (left.date == right.date) &&
            (left.description == right.description) &&
            (left.label == right.label)
    }
}
