//
//  DoughnutChartData.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

public class DoughnutChartData: DoughnutChartDataProtocol {

    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : PieDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var chartStyle    : DoughnutChartStyle
    @Published public var legends       : [LegendData]
    @Published public var infoView      : InfoViewData<PieChartDataPoint>
         
    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : PieDataSet,
                metadata    : ChartMetadata? = nil,
                chartStyle  : DoughnutChartStyle  = DoughnutChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
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
