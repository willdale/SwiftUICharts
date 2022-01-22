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
public final class GroupedBarChartData: BarChartType, CTChartData, CTMultiBarChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: GroupedBarDataSets
    @Published public var barStyle: BarStyle
    @Published public var legends: [LegendData] = []
    @Published public var shouldAnimate: Bool
    public var noDataText: Text
    public var accessibilityTitle: LocalizedStringKey = ""
        
    // MARK: Multi
    @Published public var groupSpacing: CGFloat = 0
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
    @Published public var infoView = InfoViewData<GroupedBarDataPoint>()
    
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
        let superXSection = divide(size, count)
        let spaceSection = groupSpacing * CGFloat(count - 1)
        let compensation = divide(spaceSection, count)
        let section = superXSection - compensation
        return section > 0 ? section : 0
    }
    
    public func xAxisLabelOffSet(index: Int, size: CGFloat, count: Int) -> CGFloat {
        let superXSection = divide(size, count)
        let compensation = ((groupSpacing * CGFloat(count - 1)) / CGFloat(count))
        return (CGFloat(index) * superXSection) +
                ((CGFloat(index) * compensation) / CGFloat(count)) +
                (xAxisSectionSizing(count: count, size: size) / 2)
    }
    
    // MARK: Touch
    public func processTouchInteraction(_ markerData: MarkerData, touchLocation: CGPoint, chartSize: CGRect) {
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
        let barMarkerData = values.map { data in
            return BarMarkerData(markerType: self.touchMarkerType,
                                 location: data.location)
        }
        markerData.update(with: barMarkerData)
    }
    
    public func touchDidFinish() {
        touchPointData = []
    }
    
    public typealias SetType = GroupedBarDataSets
    public typealias DataPoint = GroupedBarDataPoint
    public typealias Marker = BarMarkerType
}
