//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class MultiLineChartData: ChartData {
        
    public let id   : UUID  = UUID()
    
    /// Data model containing the datapoints: Value, Label, Description and Date. Individual colouring for bar chart.
    @Published public var dataSets      : Set
    
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    @Published public var metadata      : ChartMetadata?
    
    /// Array of strings for the labels on the X Axis instead of the the dataPoints labels.
    @Published public var xAxisLabels   : [String]?
    
    /// Data model conatining the style data for the chart.
    @Published public var chartStyle    : ChartStyle
                
    /// Array of data to populate the chart legend.
    @Published public var legends       : [LegendData]
    
    /// Data model to hold data about the Views layout.
    @Published public var viewData      : ChartViewData<LineChartDataPoint>
    
    public var noDataText   : Text = Text("No Data")
    
    public var chartType    : (ChartType, DataSetType)
            
    public init(dataSets    : Set,
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
        self.chartType      = (.line, .multi)
    }
    
    public init(dataSets    : Set,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : ChartStyle        = ChartStyle(),
                customCalc  : @escaping ([LineChartDataPoint]) -> [LineChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.line, .multi)
    }
    
    public typealias Set = MultiLineDataSet
}
