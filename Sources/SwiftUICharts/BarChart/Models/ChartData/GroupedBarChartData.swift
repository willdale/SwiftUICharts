//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI
import Combine
import ChartMath

/**
 Data model for drawing and styling a Grouped Bar Chart.
 
 The grouping data informs the model as to how the datapoints are linked.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class GroupedBarChartData: BarChartType, CTChartData, CTMultiBarChartDataProtocol, StandardChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: GroupedBarDataSets
    public var barStyle: BarStyle
    public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
    public let chartName: ChartName = .groupedBar
    
    public var markerData = MarkerData()
    
    public var stateObject = ChartStateObject()
    public var touchObject = ChartTouchObject()
    
    // MARK: Multi
    public var groupSpacing: CGFloat = 0
    public var groups: [GroupingData]
    
    // MARK: Publishable
    public var touchedData = TouchedData<DataPoint>()
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: Non-Protocol
    internal let chartType: CTChartType = (chartType: .bar, dataSetType: .multi)
    
    // MARK: Initializer
    /// Initialises a Grouped Bar Chart.
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
        dataSets: GroupedBarDataSets,
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
    
    // MARK: Touch
    public func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        var values: [PublishedTouchData<DataPoint>] = []
        // Divide the chart into equal sections.
        let superXSection = chartSize.width / CGFloat(dataSets.dataSets.count)
        let superIndex = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection = superXSection - compensation
        let ySection = chartSize.height / CGFloat(self.maxValue)
        
        let index = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)
        
        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            let subDataSet = dataSets.dataSets[index]
            let xSubSection: CGFloat = (xSection / CGFloat(subDataSet.dataPoints.count))
            let subIndex: Int = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(index))) / xSubSection) - (subDataSet.dataPoints.count * index)
            if subIndex >= 0 && subIndex < subDataSet.dataPoints.count {
                let element: CGFloat = (CGFloat(subIndex) * xSubSection) + (xSubSection / 2)
                let section: CGFloat = (superXSection * CGFloat(superIndex))
                let spacing: CGFloat = ((groupSpacing / CGFloat(dataSets.dataSets.count)) * CGFloat(superIndex))
                
                let location =  CGPoint(x: element + section + spacing,
                                        y: (chartSize.height - CGFloat(subDataSet.dataPoints[subIndex].value) * ySection))
                let datapoint = dataSets.dataSets[index].dataPoints[subIndex]
                
                values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))
            }
        }
        markerData = MarkerData(barMarkerData: values.map { data in
            return BarMarkerData(markerType: dataSets.markerType,
                                 location: data.location)
        })
    }
    
    public func touchDidFinish() {
        touchedData.touchPointData = []
    }
    
    public typealias SetType = GroupedBarDataSets
    public typealias DataPoint = GroupedBarDataPoint
    public typealias Marker = BarMarkerType
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    public var chartStyle = BarChartStyle()
    @available(*, deprecated, message: "Has been moved to the view")
    public var legends: [LegendData] = []
    @available(*, deprecated, message: "Split in to axis data")
    public var infoView = InfoViewData<GroupedBarDataPoint>()
    @available(*, deprecated, message: "Please use \".xAxisLabels\" instead.")
    public var xAxisLabels: [String]?
    @available(*, deprecated, message: "Please use \".yAxisLabels\" instead.")
    public var yAxisLabels: [String]?
}
