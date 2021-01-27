//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

public class MultiBarChartData: LineAndBarChartData {

    public let id   : UUID  = UUID()

    @Published public var dataSets     : MultiBarDataSet
    @Published public var metadata     : ChartMetadata?
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData<BarChartDataPoint>
    public var noDataText   : Text  = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : MultiBarDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : BarChartStyle     = BarChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .bar, dataSetType: .multi)
    }
    
    public init(dataSets    : MultiBarDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : BarChartStyle     = BarChartStyle(),
                customCalc  : @escaping ([BarChartDataPoint]) -> [BarChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .bar, dataSetType: .multi)
    }
    
    public func legendOrder() -> [LegendData] {
        return [LegendData]()
    }

    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
    
    public typealias Set = MultiBarDataSet
    public typealias DataPoint = BarChartDataPoint
}

