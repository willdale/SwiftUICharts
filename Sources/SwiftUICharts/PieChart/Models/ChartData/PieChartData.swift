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
@available(macOS 11.0, iOS 13, watchOS 7, tvOS 14, *)
public final class PieChartData: CTPieChartDataProtocol, Publishable, Touchable {
    
    // MARK: Properties
    public var id: UUID = UUID()
    @Published public var dataSets: PieDataSet
    @Published public var metadata: ChartMetadata
    @Published public var chartStyle: PieChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var infoView: InfoViewData<PieChartDataPoint> = InfoViewData()
    
    public var noDataText: Text
    
    public var subscription = Set<AnyCancellable>()
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<PieChartDataPoint>],Never>()
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .pie, dataSetType: .single)
    
    @Published public var touchPointData: [DataPoint] = []
    
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
        self.noDataText = noDataText
        
        self.setupLegends()
        self.makeDataPoints()
    }
    
    // MARK: - Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let touchDegree = degree(from: touchLocation, in: chartSize)
        let index = self.dataSets.dataPoints.firstIndex(where:) {
            let start = $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree)
            let end = ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree)
            return start && end
        }
        guard let wrappedIndex = index else { return }
        let datapoint = self.dataSets.dataPoints[wrappedIndex]
//        self.touchedDataPointPublisher.send([PublishedTouchData(datapoint: datapoint, location: .zero)])
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
    
    public typealias SetType = PieDataSet
    public typealias DataPoint = PieChartDataPoint
    public typealias CTStyle = PieChartStyle
}

