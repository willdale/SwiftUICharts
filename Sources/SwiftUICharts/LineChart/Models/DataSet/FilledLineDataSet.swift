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
    public var marketType: LineMarkerType
    public var style: FilledLineStyle

    public init(
        dataPoints: [LineChartDataPoint],
        marketType: LineMarkerType = .full(attachment: .line(dot: .style(DotStyle())), colour: .primary, style: StrokeStyle()),
        style: FilledLineStyle = FilledLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.marketType = marketType
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
        self.marketType = .none
        self.pointStyle = pointStyle
        self.style = style
    }
    
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public var pointStyle = PointStyle()
    @available(*, deprecated, message: "depricated")
    public var legendTitle: String = ""
}
