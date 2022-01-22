//
//  StackedBarChartData.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI
import Combine
import ChartMath

/**
 Data model for drawing and styling a Stacked Bar Chart.
 
 The grouping data informs the model as to how the datapoints are linked.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class StackedBarChartData: BarChartType, CTChartData, CTBarChartDataProtocol, CTMultiBarChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: StackedBarDataSets
    @Published public var barStyle: BarStyle
    @Published public var legends: [LegendData] = []
    @Published public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
        
    // MARK: Multi
    @Published public var groups: [GroupingData]
    
    // MARK: ViewDataProtocol
    @Published public var xAxisViewData = XAxisViewData()
    @Published public var yAxisViewData = YAxisViewData()
    
    // MARK: ChartAxes
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []

    // MARK: Touchable
    public var touchMarkerType: BarMarkerType = defualtTouchMarker
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: ExtraLineDataProtocol
    @Published public var extraLineData: ExtraLineData!
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .bar, dataSetType: .multi)
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    @Published public var chartStyle = BarChartStyle()
    @available(*, deprecated, message: "Split in to axis data")
    @Published public var infoView = InfoViewData<StackedBarDataPoint>()
    
    // MARK: Initializer
    /// Initialises a Stacked Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: StackedBarDataSets,
        groups: [GroupingData],
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.groups = groups
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
        
//        self.setupLegends()
    }
    
    // MARK: Labels
    public func xAxisSectionSizing(count: Int, size: CGFloat) -> CGFloat {
        return divide(size, count)
    }
    
    public func xAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat {
       return CGFloat(index) * divide(size, count) +
        (xAxisSectionSizing(count: count, size: size) / 2)
    }

    // MARK: - Touch
    public func processTouchInteraction(_ markerData: MarkerData, touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        // Filter to get the right dataset based on the x axis.
        let superXSection: CGFloat = chartSize.width / CGFloat(dataSets.dataSets.count)
        let superIndex: Int = Int((touchLocation.x) / superXSection)
        if superIndex >= 0 && superIndex < dataSets.dataSets.count {
            // Filter to get the right dataset based on the y axis.
            let subDataSet = dataSets.dataSets[superIndex]
            let calculatedIndex = calculateIndex(dataSet: subDataSet, touchLocation: touchLocation, chartSize: chartSize)
            if let index = calculatedIndex.yIndex?.offset {
                if index >= 0 && index < subDataSet.dataPoints.count {
                    let datapoint = dataSets.dataSets[superIndex].dataPoints[index]
                    let location = CGPoint(x: (CGFloat(superIndex) * superXSection) + (superXSection / 2),
                                           y: (chartSize.height - calculatedIndex.endPointOfElements[index]))
                    values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
                    
                    if let extraLine = extraLineData?.pointAndLocation(touchLocation: touchLocation, chartSize: chartSize),
                       let location = extraLine.location,
                       let value = extraLine.value,
                       let description = extraLine.description,
                       let _legendTag = extraLine._legendTag
                    {
                        var datapoint = DataPoint(value: value, description: description)
                        datapoint._legendTag = _legendTag
                        values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .extraLine))
                    }
                    
                }
            }
        }
        let barMarkerData = values.map { data in
            return BarMarkerData(markerType: self.touchMarkerType,
                                 location: data.location)
        }
        markerData.update(with: barMarkerData)
    }

    private func calculateIndex(
        dataSet: StackedBarDataSet,
        touchLocation: CGPoint,
        chartSize: CGRect
    ) -> (yIndex: EnumeratedSequence<[CGFloat]>.Element?, endPointOfElements: [CGFloat]) {
        
        // Get the max value of the dataset relative to max value of all datasets.
        // This is used to set the height of the y axis filtering.
        let setMaxValue = dataSet.maxValue()
        let allMaxValue = self.maxValue
        let fraction: CGFloat = CGFloat(setMaxValue / allMaxValue)
        
        // Gets the height of each datapoint
        let sum: Double = dataSet.dataPoints
            .map(\.value)
            .reduce(0, +)
        let heightOfElements: [CGFloat] = dataSet.dataPoints
            .map(\.value)
            .map { (chartSize.height * fraction) * CGFloat($0 / sum) }
        
        // Gets the highest point of each element.
        let endPointOfElements: [CGFloat] = heightOfElements
            .enumerated()
            .map {
                (0...$0.offset)
                    .map { heightOfElements[$0] }
                    .reduce(0, +)
            }
        
        let yIndex = endPointOfElements
            .enumerated()
            .first(where:) { $0.element > abs(touchLocation.y - chartSize.height) }
        
        return (yIndex, endPointOfElements)
    }
    
    public func touchDidFinish() {
        touchPointData = []
    }
    
    public typealias SetType = StackedBarDataSets
    public typealias DataPoint = StackedBarDataPoint
    public typealias Marker = BarMarkerType
}
