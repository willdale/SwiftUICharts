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
public final class MultiLineChartData: LineChartType, CTChartData, CTLineChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: MultiLineDataSet
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
    public var touchMarkerType: LineMarkerType = defualtTouchMarker
    
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
        ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
            PointsSubView(chartData: self,
                          dataSets: dataSet,
                          minValue: self.minValue,
                          range: self.range,
                          animation: self.chartStyle.globalAnimation)
        }
    }
    
    // MARK: Touch
    public func processTouchInteraction(_ markerData: inout MarkerData, touchLocation: CGPoint) {
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
                    datapoint._legendTag = dataSet.legendTitle
                } else {
                    return nil
                }
            }
            return PublishedTouchData(datapoint: datapoint, location: location, type: .line)
        }
        
        values.append(contentsOf: data)
        
        if let extraLine = extraLineData?.pointAndLocation(touchLocation: touchLocation, chartSize: chartSize),
           let location = extraLine.location,
           let value = extraLine.value
        {
            var datapoint = DataPoint(value: value, description: extraLine.description ?? "")
            datapoint._legendTag = extraLine._legendTag ?? ""
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .extraLine))
        }
        
        var lineMarkerData: [LineMarkerData] = []
        values.forEach { data in
            let location = data.location
            let lineData = self.dataSets.dataSets.compactMap { dataSet in
                return LineMarkerData(markerType: self.touchMarkerType,
                                      location: location,
                                      dataPoints: dataSet.dataPoints,
                                      lineType: dataSet.style.lineType,
                                      lineSpacing: .line,
                                      minValue: self.minValue,
                                      range: self.range)
            }
            lineMarkerData.append(contentsOf: lineData)
        }
        markerData.update(with: lineMarkerData)
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
                    .accessibilityValue(dataSet.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
            }
        }
    }
    
    public typealias SetType = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias Marker = LineMarkerType
}
