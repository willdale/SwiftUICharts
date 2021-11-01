//
//  DoughnutChartData.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a doughnut chart.
 
 This model contains the data and styling information for a doughnut chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class DoughnutChartData: CTDoughnutChartDataProtocol, Publishable, Touchable, TouchInfoDisplayable {
    
    // MARK: Properties
    public var id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: PieDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var chartStyle: DoughnutChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var infoView: InfoViewData<PieChartDataPoint> = InfoViewData()
    
    @Published public var shouldAnimate: Bool = false
        
    public var noDataText: Text

    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .pie, dataSetType: .single)
    
    private var internalDataSubscription: AnyCancellable?
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<PieChartDataPoint>],Never>()
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Initializer
    /// Initialises Doughnut Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: PieDataSet,
        chartStyle: DoughnutChartStyle = DoughnutChartStyle(),
        noDataText: Text
    ) {
        self.dataSets = dataSets
        self.chartStyle = chartStyle
        self.noDataText = noDataText
        
        self.setupLegends()
        self.makeDataPoints()
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
    
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
        self.touchedDataPointPublisher.send([PublishedTouchData(datapoint: datapoint, location: .zero, type: .pie)])
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View { EmptyView() }
    
    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
    }
    
    public typealias SetType = PieDataSet
    public typealias DataPoint = PieChartDataPoint
    public typealias CTStyle = DoughnutChartStyle
    
    // MARK: Deprecated
    /// Initialises Doughnut Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: PieDataSet,
        metadata: ChartMetadata,
        chartStyle: DoughnutChartStyle = DoughnutChartStyle(),
        noDataText: Text
    ) {
        self.dataSets = dataSets
        self.metadata = metadata
        self.chartStyle = chartStyle
        self.noDataText = noDataText
        
        self.setupLegends()
        self.makeDataPoints()
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
}
