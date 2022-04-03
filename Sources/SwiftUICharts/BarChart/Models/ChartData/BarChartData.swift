//
//  BarChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI
import Combine
import ChartMath

/**
 Data for drawing and styling a standard Bar Chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class BarChartData: BarChartType, CTChartData, CTBarChartDataProtocol, StandardChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: BarDataSet
    public var barStyle: BarStyle
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .bar
    
    public var markerData = MarkerData()
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (.bar, .single)
    
    // MARK: Initializer
    /// Initialises a standard Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: BarDataSet,
        barStyle: BarStyle = BarStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.barStyle = barStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
    }
    
    // MARK: - Touch
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let ySection: CGFloat = chartSize.height / CGFloat(dataSets.maxValue())
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let location = CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                   y: (chartSize.size.height - CGFloat(dataSets.dataPoints[index].value) * ySection))
            
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
        }
        markerData = MarkerData(barMarkerData: values.map { data in
            return BarMarkerData(markerType: dataSets.marketType,
                                 location: data.location)
        })
    }

    public func touchDidFinish() {
        touchPointData = []
    }
    
    public typealias SetType = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias Marker = BarMarkerType
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    public var chartStyle = BarChartStyle()
    @available(*, deprecated, message: "Has been moved to the view")
    public var legends: [LegendData] = []
    @available(*, deprecated, message: "Split in to axis data")
    public var infoView = InfoViewData<BarChartDataPoint>()
    @available(*, deprecated, message: "Please use \".xAxisLabels\" instead.")
    public var xAxisLabels: [String]?
    @available(*, deprecated, message: "Please use \".yAxisLabels\" instead.")
    public var yAxisLabels: [String]?
}
