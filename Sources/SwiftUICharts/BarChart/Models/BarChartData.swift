//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public class BarChartData: ChartData {
    
    public let id   : UUID  = UUID()

    @Published public var dataSets     : [Set]
    @Published public var metadata     : ChartMetadata?
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : ChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    public var noDataText   : Text  = Text("No Data")

    public init(dataSets    : [BarDataSet],
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : ChartStyle        = ChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
    }
    
    public init(dataSets    : [BarDataSet],
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : ChartStyle        = ChartStyle(),
                customCalc  : @escaping ([ChartDataPoint]) -> [ChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
    }
    
    public func legendOrder() -> [LegendData] {
        return [LegendData]()
    }

    public typealias Set = BarDataSet

}
