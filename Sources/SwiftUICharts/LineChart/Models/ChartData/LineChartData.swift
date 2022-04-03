//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI
import Combine
import ChartMath

/**
 Data for drawing and styling a single line, line chart.
 
 This model contains the data and styling information for a single line, line chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class LineChartData: LineChartType, CTChartData, CTLineChartDataProtocol, StandardChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: LineDataSet
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .line
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Touchable
    public var touchMarkerType: LineMarkerType = defualtTouchMarker
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Initializer
    /// Initialises a Single Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: LineDataSet,
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
    }

    // MARK: Touch
    public func processTouchInteraction(_ markerData: MarkerData, touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []

        let xSection = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection = chartSize.height / CGFloat(range)

        let index = Int(divide((touchLocation.x + (xSection / 2)), xSection))
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let location = CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(datapoint.value - minValue) * -ySection) + chartSize.height)
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
        }
        
        touchPointData = values.map(\.datapoint)
        
        let lineMarkerData = values.map {
            return LineMarkerData(markerType: touchMarkerType,
                                  location: $0.location,
                                  dataPoints: dataSets.dataPoints,
                                  lineType: dataSets.style.lineType,
                                  lineSpacing: .line,
                                  minValue: minValue,
                                  range: range)
        }
        markerData.update(with: lineMarkerData)
    }
    
    public func touchDidFinish() {
        touchPointData = []
    }
    
    public typealias SetType = LineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias Marker = LineMarkerType
    
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    public var chartStyle = LineChartStyle()
    @available(*, deprecated, message: "Has been moved to the view")
    public var legends: [LegendData] = []
    @available(*, deprecated, message: "Split in to axis data")
    public var infoView = InfoViewData<LineChartDataPoint>()
    @available(*, deprecated, message: "Please use \".xAxisLabels\" instead.")
    public var xAxisLabels: [String]?
    @available(*, deprecated, message: "Please use \".yAxisLabels\" instead.")
    public var yAxisLabels: [String]?
}
