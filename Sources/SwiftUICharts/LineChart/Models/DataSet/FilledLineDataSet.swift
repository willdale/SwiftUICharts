//
//  FilledLineDataSet.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI

/// Data set for a single line
///
/// Contains information specific to each line within the chart .
public struct FilledLineDataSet: CTDataSetProtocol {
    
    public let id: UUID = UUID()
    public var dataPoints: [LineChartDataPoint]
    public var markerType: LineMarkerType
    public var style: FilledLineStyle

    public init(
        dataPoints: [LineChartDataPoint],
        markerType: LineMarkerType = .full(attachment: .line, colour: .primary, style: StrokeStyle()),
        style: FilledLineStyle = FilledLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.markerType = markerType
        self.style = style
    }
}
