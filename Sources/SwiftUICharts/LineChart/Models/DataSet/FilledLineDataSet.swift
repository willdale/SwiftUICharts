//
//  FilledLineDataSet.swift
//  
//
//  Created by Will Dale on 05/12/2021.
//

import SwiftUI

public struct FilledLineDataSet: CTLineChartDataSet, DataFunctionsProtocol {
    
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
    
    @available(*, deprecated, message: "\"PointStyle\" and \"legendTitle\" has been depricated")
    public init(
        dataPoints: [LineChartDataPoint],
        legendTitle: String,
        pointStyle: PointStyle = PointStyle(),
        style: FilledLineStyle = FilledLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.markerType = .none
        self.pointStyle = pointStyle
        self.style = style
    }
    
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public var pointStyle = PointStyle()
    @available(*, deprecated, message: "depricated")
    public var legendTitle: String = ""
}
