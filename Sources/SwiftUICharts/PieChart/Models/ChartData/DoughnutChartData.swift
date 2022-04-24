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
public final class DoughnutChartData: PieChartType, CTDoughnutChartDataProtocol, Publishable, Touchable {
    // MARK: Properties
    public var id: UUID = UUID()
    @Published public var dataSets: PieDataSet
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .doughnut
    
    public var markerData = MarkerData()
    
    public var strokeWidth: CGFloat = 1

    // MARK: Publishable
    public var touchedData = TouchedData<DataPoint>()
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .pie, dataSetType: .single)
    
    // MARK: Initializer
    /// Initialises Doughnut Chart data.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: PieDataSet,
        shouldAnimate: Bool = true,
        noDataText: Text
    ) {
        self.dataSets = dataSets
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        
        self.makeDataPoints()
    }

    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let touchDegree = degree(from: touchLocation, in: chartSize)
        let index = self.dataSets.dataPoints.firstIndex(where:) {
            let start = $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree)
            let end = ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree)
            return start && end
        }
        guard let wrappedIndex = index else { return }
        let datapoint = self.dataSets.dataPoints[wrappedIndex]
        let values = [PublishedTouchData(datapoint: datapoint, location: .zero, type: .pie)]
        markerData = MarkerData(pieMarkerData: values.map { data in
            return PieMarkerData(markerType: dataSets.markerType, location: data.location)
        })
    }
        
    public func touchDidFinish() {
        touchedData.touchPointData = []
    }
    
    public typealias SetType = PieDataSet
    public typealias DataPoint = PieChartDataPoint
    public typealias Marker = PieMarkerType
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    public var chartStyle = DoughnutChartStyle()
    @available(*, deprecated, message: "Has been moved to the view")
    public var legends: [LegendData] = []
    @available(*, deprecated, message: "Split in to axis data")
    public var infoView = InfoViewData<PieChartDataPoint>()
}
