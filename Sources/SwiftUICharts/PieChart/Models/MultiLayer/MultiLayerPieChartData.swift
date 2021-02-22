//
//  MultiLayerPieChartData.swift
//
//
//  Created by Will Dale on 05/02/2021.
//

import SwiftUI

public final class MultiLayerPieChartData: MultiPieChartDataProtocol {
    
    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : MultiPieDataSet
    @Published public var metadata      : ChartMetadata
    @Published public var chartStyle    : PieChartStyle
    @Published public var legends       : [LegendData]
    @Published public var infoView      : InfoViewData<MultiPieDataPoint>
            
    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : MultiPieDataSet,
                metadata    : ChartMetadata,
                chartStyle  : PieChartStyle  = PieChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
        self.infoView    = InfoViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .single)
        
//        self.setupLegends()

        self.makeDataPoints()
    }
    
    public func touchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View { EmptyView() }
    
    
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [MultiPieDataPoint] {
        let points : [MultiPieDataPoint] = []
        return points
    }
    
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        return [HashablePoint(x: touchLocation.x, y: touchLocation.y)]
    }
    
    internal func setupLegends() {}
    
    internal func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }

    public typealias Set       = MultiPieDataSet
    public typealias DataPoint = MultiPieDataPoint
    public typealias CTStyle   = PieChartStyle
}
