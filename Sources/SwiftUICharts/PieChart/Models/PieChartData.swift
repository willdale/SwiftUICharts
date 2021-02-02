//
//  PieChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

public class PieChartData: PieChartDataProtocol {
    
    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : PieDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : PieChartStyle
    @Published public var legends       : [LegendData]
    @Published public var infoView      : InfoViewData<PieChartDataPoint>
            
    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : PieDataSet,
                metadata    : ChartMetadata? = nil,
                xAxisLabels : [String]?      = nil,
                chartStyle  : PieChartStyle  = PieChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
        self.xAxisLabels = xAxisLabels
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
        self.infoView    = InfoViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .single)
        
        self.setupLegends()
        
        self.makeDataPoints()
    }
    
    
    public typealias Set = PieDataSet
    public typealias DataPoint = PieChartDataPoint
}

public class DoughnutChartData: DoughnutChartDataProtocol {

    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : PieDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : DoughnutChartStyle
    @Published public var legends       : [LegendData]
    @Published public var infoView      : InfoViewData<PieChartDataPoint>
     
    let strokeWidth: CGFloat = 30
    
    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : PieDataSet,
                metadata    : ChartMetadata? = nil,
                xAxisLabels : [String]?      = nil,
                chartStyle  : DoughnutChartStyle  = DoughnutChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
        self.xAxisLabels = xAxisLabels
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
        self.infoView    = InfoViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .single)
        
        self.setupLegends()
        
        self.makeDataPoints()
    }

    public typealias Set = PieDataSet
    public typealias DataPoint = PieChartDataPoint
}
