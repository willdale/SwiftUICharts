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
public final class LineChartData: LineChartType, CTChartData, CTLineChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: LineDataSet
    @Published public var legends: [LegendData] = []
    @Published public var shouldAnimate: Bool
    @Published public var chartSize: CGRect = .zero
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
        
    // MARK: ViewDataProtocol
    @Published public var xAxisViewData = XAxisViewData()
    @Published public var yAxisViewData = YAxisViewData()
    
    // MARK: ChartAxes
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Touchable
    @Published public var touchMarkerType: LineMarkerType = defualtTouchMarker
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: ExtraLineDataProtocol
    @Published public var extraLineData: ExtraLineData!
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    @Published public var chartStyle = LineChartStyle()
    @available(*, deprecated, message: "Split in to axis data")
    @Published public var infoView = InfoViewData<LineChartDataPoint>()
    
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
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
        
//        self.setupLegends()
    }

    
    // MARK: Labels
    public func xAxisSectionSizing(count: Int, size: CGFloat) -> CGFloat {
        return min(divide(size, count),
                   self.xAxisViewData.xAxisLabelWidths.min() ?? 0)
    }
    
    public func xAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat {
       return CGFloat(index) * divide(size, count - 1)
    }
    
    // MARK: Points
    public func getPointMarker() -> some View {
        PointsSubView(chartData: self,
                      dataSets: dataSets,
                      minValue: minValue,
                      range: range,
                      animation: chartStyle.globalAnimation)
    }

    // MARK: Touch
    public func processTouchInteraction(_ data: inout MarkerData, touchLocation: CGPoint) {
        var values: [PublishedTouchData<DataPoint>] = []

        let xSection = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection = chartSize.height / CGFloat(range)

        let index = Int(divide((touchLocation.x + (xSection / 2)), xSection))
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let location = CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(datapoint.value - minValue) * -ySection) + chartSize.height)
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))

            if let extraLine = extraLineData?.pointAndLocation(touchLocation: touchLocation, chartSize: chartSize),
               let location = extraLine.location,
               let value = extraLine.value
            {
                var datapoint = DataPoint(value: value, description: extraLine.description ?? "")
                datapoint._legendTag = extraLine._legendTag ?? ""
                values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .extraLine))
            }
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
        data.update(with: lineMarkerData)
    }
    
    public func touchDidFinish() {
        touchPointData = []
    }
    
    public typealias SetType = LineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias Marker = LineMarkerType
}
