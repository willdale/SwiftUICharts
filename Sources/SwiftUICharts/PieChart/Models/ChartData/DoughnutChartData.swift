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
     let data = PieDataSet(dataPoints: [PieChartDataPoint(value: 7, description: "One",   colour: .blue),
                                        PieChartDataPoint(value: 2, description: "Two",   colour: .red),
                                        PieChartDataPoint(value: 9, description: "Three", colour: .purple),
                                        PieChartDataPoint(value: 6, description: "Four",  colour: .green),
                                        PieChartDataPoint(value: 4, description: "Five",  colour: .orange)],
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
    @Published public final var dataSets   : PieDataSet
    @Published public final var metadata   : ChartMetadata
    @Published public final var chartStyle : DoughnutChartStyle
    @Published public final var legends    : [LegendData]
    @Published public final var infoView   : InfoViewData<PieChartDataPoint>
         
    public final var noDataText: Text
    public final var chartType : (chartType: ChartType, dataSetType: DataSetType)
    
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
    
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }

    public typealias Set        = PieDataSet
    public typealias DataPoint  = PieChartDataPoint
    public typealias CTStyle    = DoughnutChartStyle
}

// MARK: - Touch
extension DoughnutChartData {
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        var points : [PieChartDataPoint] = []
        let touchDegree = degree(from: touchLocation, in: chartSize)
                
        let dataPoint = self.dataSets.dataPoints.first(where: { $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree) && ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree) } )
        if let data = dataPoint {
            var finalDataPoint = data
            finalDataPoint.legendTag = dataSets.legendTitle
            points.append(finalDataPoint)
        }
        self.infoView.touchOverlayInfo = points
    }
    public func getPointLocation(dataSet: PieDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        return nil
    }
}
