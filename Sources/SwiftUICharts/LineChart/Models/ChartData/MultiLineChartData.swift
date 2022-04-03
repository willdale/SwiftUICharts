//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI
import Combine
import ChartMath

/**
 Data for drawing and styling a multi line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class MultiLineChartData: LineChartType, CTChartData, CTLineChartDataProtocol, StandardChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: MultiLineDataSet
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .multiLine
    
    public var markerData = MarkerData()
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .line, dataSetType: .single)
    
    // MARK: Initializers
    /// Initialises a Multi Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: MultiLineDataSet,
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
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        let data: [PublishedTouchData<LineChartDataPoint>] = dataSets.dataSets.compactMap { dataSet in
            let xSection = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection = chartSize.height / CGFloat(range)
            let index = Int((touchLocation.x + (xSection / 2)) / xSection)
            
            var location: CGPoint = .zero
            var datapoint: LineChartDataPoint = LineChartDataPoint(value: 0)
            
            if index >= 0 && index < dataSet.dataPoints.count {
                if !dataSet.dataPoints[index].ignore {
                    location = CGPoint(x: CGFloat(index) * xSection,
                                       y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                    datapoint = dataSet.dataPoints[index]
                } else {
                    return nil
                }
            }
            return PublishedTouchData(datapoint: datapoint, location: location, type: .line)
        }
        
        values.append(contentsOf: data)
        
        var lineMarkerData: [LineMarkerData] = []
        values.forEach { data in
            let location = data.location
            let lineData = self.dataSets.dataSets.compactMap { dataSet in
                return LineMarkerData(markerType: dataSet.marketType,
                                      location: location,
                                      dataPoints: dataSet.dataPoints,
                                      lineType: dataSet.style.lineType,
                                      lineSpacing: .line,
                                      minValue: self.minValue,
                                      range: self.range)
            }
            lineMarkerData.append(contentsOf: lineData)
            markerData = MarkerData(lineMarkerData: lineMarkerData)
        }
    }
    
    public func touchDidFinish() {
        touchPointData = []
    }
    
    // MARK: Accessibility
    public func getAccessibility() -> some View {
        ForEach(self.dataSets.dataSets, id: \.self) { dataSet in
            ForEach(dataSet.dataPoints.indices, id: \.self) { point in
                AccessibilityRectangle(dataPointCount: dataSet.dataPoints.count,
                                       dataPointNo: point)
                    .foregroundColor(Color(.gray).opacity(0.000000001))
                    .accessibilityLabel(self.accessibilityTitle)
//                    .accessibilityValue(dataSet.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
            }
        }
    }
    
    public typealias SetType = MultiLineDataSet
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
