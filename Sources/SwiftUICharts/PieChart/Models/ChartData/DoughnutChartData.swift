//
//  DoughnutChartData.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/**
 Data for drawing and styling a doughnut chart.
 
 This model contains the data and styling information for a doughnut chart.
 
 # Example
 ```
 static func makeData() -> DoughnutChartData {
     let data = PieDataSet(dataPoints: [PieChartDataPoint(value: 7, pointDescription: "One",   colour: .blue),
                                        PieChartDataPoint(value: 2, pointDescription: "Two",   colour: .red),
                                        PieChartDataPoint(value: 9, pointDescription: "Three", colour: .purple),
                                        PieChartDataPoint(value: 6, pointDescription: "Four",  colour: .green),
                                        PieChartDataPoint(value: 4, pointDescription: "Five",  colour: .orange)],
                           legendTitle: "Data")
 
     return DoughnutChartData(dataSets: data,
                              metadata: ChartMetadata(title: "Pie", subtitle: "mmm doughnuts"),
                              chartStyle: DoughnutChartStyle(infoBoxPlacement: .header),
                              noDataText: Text("No Data"))
 }
 ```
 */
public final class DoughnutChartData: CTDoughnutChartDataProtocol {

    // MARK: Properties
    public var id : UUID = UUID()
    @Published public var dataSets   : PieDataSet
    @Published public var metadata   : ChartMetadata
    @Published public var chartStyle : DoughnutChartStyle
    @Published public var legends    : [LegendData]
    @Published public var infoView   : InfoViewData<PieChartDataPoint>
         
    public var noDataText: Text
    public var chartType : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: Initializer
    /// Initialises a Doughnut Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - chartStyle : The style data for the aesthetic of the chart.
    ///   - noDataText : Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : PieDataSet,
                metadata    : ChartMetadata,
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
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize.frame(in: .local)
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View { EmptyView() }

    public typealias Set        = PieDataSet
    public typealias DataPoint  = PieChartDataPoint
    public typealias CTStyle    = DoughnutChartStyle
}

// MARK: - Touch
extension DoughnutChartData: TouchProtocol {
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) {
        var points : [PieChartDataPoint] = []
        let touchDegree = degree(from: touchLocation, in: chartSize.frame(in: .local))
                
        let dataPoint = self.dataSets.dataPoints.first(where: { $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree) && ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree) } )
        if let data = dataPoint {
            points.append(data)
        }
        self.infoView.touchOverlayInfo = points
    }
}

// MARK: - Legends
extension DoughnutChartData: LegendProtocol {
    func setupLegends() {}
    
    internal func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}
