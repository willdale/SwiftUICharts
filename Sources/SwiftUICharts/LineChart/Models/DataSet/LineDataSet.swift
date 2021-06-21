//
//  LineDataSet.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data set for a single line
 
 Contains information specific to each line within the chart .
 */
public struct LineDataSet: CTLineChartDataSet, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataPoints: [LineChartDataPoint]
    public var legendTitle: String
    public var pointStyle: PointStyle
    public var style: LineStyle
    
    /// Initialises a data set for a line in a Line Chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be draw in.
    public init(
        dataPoints: [LineChartDataPoint],
        legendTitle: String = "",
        pointStyle: PointStyle = PointStyle(),
        style: LineStyle = LineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.pointStyle = pointStyle
        self.style = style
    }
    
    public typealias ID = UUID
    public typealias Styling = LineStyle
}
