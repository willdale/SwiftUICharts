//
//  RangedLineDataSet.swift
//  
//
//  Created by Will Dale on 02/03/2021.
//

import SwiftUI

/**
 Data set for a ranged line.
 
 Contains information specific to the line and range fill.
 */
public struct RangedLineDataSet: CTRangedLineChartDataSet, DataFunctionsProtocol {
    
    public let id: UUID = UUID()
    public var dataPoints: [RangedLineChartDataPoint]
    public var legendTitle: String
    public var legendFillTitle: String
    public var style: RangedLineStyle
    
    /// Initialises a data set for a line in a ranged line chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    ///   - legendFillTitle: Label for the range data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be draw in.
    public init(
        dataPoints: [RangedLineChartDataPoint],
        legendTitle: String = "",
        legendFillTitle: String = "",
        style: RangedLineStyle = RangedLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.legendFillTitle = legendFillTitle
        self.style = style
    }
    
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public var pointStyle = PointStyle()
    /// Initialises a data set for a line in a ranged line chart.
    /// - Parameters:
    ///   - dataPoints: Array of elements.
    ///   - legendTitle: Label for the data in legend.
    ///   - legendFillTitle: Label for the range data in legend.
    ///   - pointStyle: Styling information for the data point markers.
    ///   - style: Styling for how the line will be draw in.
    @available(*, deprecated, message: "\"PointStyle\" has been depricated")
    public init(
        dataPoints: [RangedLineChartDataPoint],
        legendTitle: String = "",
        legendFillTitle: String = "",
        pointStyle: PointStyle = PointStyle(),
        style: RangedLineStyle = RangedLineStyle()
    ) {
        self.dataPoints = dataPoints
        self.legendTitle = legendTitle
        self.legendFillTitle = legendFillTitle
        self.pointStyle = pointStyle
        self.style = style
    }
    
    public typealias ID = UUID
    public typealias Styling = RangedLineStyle
}
