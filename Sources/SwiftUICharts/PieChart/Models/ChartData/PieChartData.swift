//
//  PieChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a pie chart.
 
 This model contains the data and styling information for a pie chart.
 */
public final class PieChartData: CTPieChartDataProtocol, Publishable {
    
    // MARK: Properties
    public var id: UUID = UUID()
    @Published public final var dataSets: PieDataSet
    @Published public final var metadata: ChartMetadata
    @Published public final var chartStyle: PieChartStyle
    @Published public final var legends: [LegendData]
    @Published public final var infoView: InfoViewData<PieChartDataPoint>
    
    // Publishable
    public var subscription = SubscriptionSet().subscription
    public let touchedDataPointPublisher = PassthroughSubject<DataPoint,Never>()
    
    public final var noDataText: Text
    public final var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public var disableAnimation = false
    
    // MARK: Initializer
    /// Initialises Pie Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: PieDataSet,
        metadata: ChartMetadata,
        chartStyle: PieChartStyle = PieChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.metadata = metadata
        self.chartStyle = chartStyle
        self.legends = [LegendData]()
        self.infoView = InfoViewData()
        self.noDataText = noDataText
        self.chartType = (chartType: .pie, dataSetType: .single)
        
        self.setupLegends()
        self.makeDataPoints()
    }
    
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
    
    public typealias SetType = PieDataSet
    public typealias DataPoint = PieChartDataPoint
    public typealias CTStyle = PieChartStyle
}

// MARK: - Touch
extension PieChartData {
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let touchDegree = degree(from: touchLocation, in: chartSize)
        let index = self.dataSets.dataPoints.firstIndex(where:) {
            let start = $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree)
            let end = ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree)
            return start && end
        }
        guard let wrappedIndex = index else { return }
        self.dataSets.dataPoints[wrappedIndex].legendTag = dataSets.legendTitle
        self.infoView.touchOverlayInfo = [self.dataSets.dataPoints[wrappedIndex]]
        touchedDataPointPublisher.send(self.dataSets.dataPoints[wrappedIndex])
    }
    
    public func getPointLocation(dataSet: PieDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        return nil
    }
}
