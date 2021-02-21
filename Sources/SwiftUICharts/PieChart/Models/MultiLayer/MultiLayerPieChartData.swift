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



// MARK: - Data Sets
public struct MultiPieDataSet: SingleDataSet {
    
    public var id: UUID = UUID()
    public var dataPoints  : [MultiPieDataPoint]
    
    public init(dataPoints: [MultiPieDataPoint]) {
        self.dataPoints = dataPoints
    }
    
    public typealias DataPoint = MultiPieDataPoint

}



// MARK: - Data Point
public struct MultiPieDataPoint: CTPieDataPoint {
    
    public var id: UUID = UUID()
    // CTPieDataPoint
    public var startAngle  : Double = 0
    public var amount      : Double = 0
    // CTChartDataPoint
    public var value            : Double
    public var pointDescription : String?
    public var date             : Date?
    
    public var colour           : Color
    
    public var layerDataPoints  : [MultiPieDataPoint]?
    
    public init(value           : Double,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red,
                layerDataPoints : [MultiPieDataPoint]? = nil
    ) {
        self.value              = value
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
        
        self.layerDataPoints    = layerDataPoints
        
    }

}

// MARK: - View

public struct MultiLayerPie<ChartData>: View where ChartData: MultiLayerPieChartData {
    
    @ObservedObject var chartData: ChartData

    public init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    public var body: some View {
        
        ZStack {
            ForEach(chartData.dataSets.dataPoints, id: \.self) { data in
                PieSegmentShape(id:         data.id,
                                startAngle: data.startAngle,
                                amount:     data.amount)
                    .fill(data.colour)
                
                if let points = data.layerDataPoints {
                    ForEach(points, id: \.self) { point in
                        DoughnutSegmentShape(id:         point.id,
                                             startAngle: point.startAngle,
                                             amount:     point.amount)
                            .strokeBorder(point.colour, lineWidth: 60)
                    }
                    
                }
            }
        }
    }
}
