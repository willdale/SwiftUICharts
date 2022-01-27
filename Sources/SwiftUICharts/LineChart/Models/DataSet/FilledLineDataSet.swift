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
    public var legendTitle: String
    public var style: FilledLineStyle

    public init(
        dataPoints: [LineChartDataPoint],
        legendTitle: String = "",
        style: FilledLineStyle = FilledLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.style = style
    }
    
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public init(
        dataPoints: [LineChartDataPoint],
        legendTitle: String = "",
        pointStyle: PointStyle = PointStyle(),
        style: FilledLineStyle = FilledLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.pointStyle = pointStyle
        self.style = style
    }
    
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public var pointStyle = PointStyle()
}
