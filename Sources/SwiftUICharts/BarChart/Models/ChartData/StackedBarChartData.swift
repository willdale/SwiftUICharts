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
public final class StackedBarChartData: BarChartType, CTChartData, CTBarChartDataProtocol, CTMultiBarChartDataProtocol, StandardChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: StackedBarDataSets
    public var barStyle: BarStyle
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .stackedBar
    
    public var markerData = MarkerData()
        
    // MARK: Multi
    public var groups: [GroupingData]
    
    // MARK: Publishable
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .bar, dataSetType: .multi)
    
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
        barStyle: BarStyle = BarStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data"),
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.dataSets = dataSets
        self.groups = groups
        self.barStyle = barStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        self.baseline = baseline
        self.topLine = topLine
    }

    // MARK: - Touch
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
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
                }
            }
        }
        markerData = MarkerData(barMarkerData: values.map { data in
            return BarMarkerData(markerType: dataSets.marketType,
                                 location: data.location)
        })
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
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    public var chartStyle = BarChartStyle()
    @available(*, deprecated, message: "Has been moved to the view")
    public var legends: [LegendData] = []
    @available(*, deprecated, message: "Split in to axis data")
    public var infoView = InfoViewData<StackedBarDataPoint>()
    @available(*, deprecated, message: "Please use \".xAxisLabels\" instead.")
    public var xAxisLabels: [String]?
    @available(*, deprecated, message: "Please use \".yAxisLabels\" instead.")
    public var yAxisLabels: [String]?
}
