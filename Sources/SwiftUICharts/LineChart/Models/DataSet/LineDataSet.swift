//
//  LineDataSet.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/// Data set for a single line
///
/// Contains information specific to each line within the chart .
public struct LineDataSet: CTDataSetProtocol {
    public let id: UUID = UUID()
    public var dataPoints: [LineChartDataPoint]
    public var markerType: LineMarkerType
    public var style: LineStyle
    
    public init(
        dataPoints: [LineChartDataPoint],
        markerType: LineMarkerType = .full(attachment: .line, colour: .primary, style: StrokeStyle()),
        style: LineStyle = LineStyle()
    ) {
        self.dataPoints = dataPoints
        self.markerType = markerType
        self.style = style
    }
}
