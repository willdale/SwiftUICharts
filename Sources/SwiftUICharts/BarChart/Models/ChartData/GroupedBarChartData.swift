//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI
import Combine

/**
 Data model for drawing and styling a Grouped Bar Chart.
 
 The grouping data informs the model as to how the datapoints are linked.
 ```
 */
@available(macOS 11.0, iOS 13, watchOS 7, tvOS 14, *)
public final class GroupedBarChartData: CTMultiBarChartDataProtocol, ChartConformance {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public var dataSets: GroupedBarDataSets
    @Published public var metadata: ChartMetadata
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var barStyle: BarStyle
    @Published public var chartStyle: BarChartStyle
    
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<GroupedBarDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    @Published public var groupSpacing: CGFloat = 0
    @Published public var groups: [GroupingData]
    
    public var noDataText: Text
    
    public var subscription = Set<AnyCancellable>()
    public let touchedDataPointPublisher = PassthroughSubject<PublishedTouchData<GroupedBarDataPoint>,Never>()
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .bar, dataSetType: .multi)
    
    private var internalSubscription: AnyCancellable?
    private var touchPointLocation: CGPoint = .zero
    
    // MARK: Initializer
    /// Initialises a Grouped Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: GroupedBarDataSets,
        groups: [GroupingData],
        metadata: ChartMetadata = ChartMetadata(),
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        chartStyle: BarChartStyle = BarChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.groups = groups
        self.metadata = metadata
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.chartStyle = chartStyle
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
    
    private func setupInternalCombine() {
        internalSubscription = touchedDataPointPublisher
            .map(\.location)
            .assign(to: \.touchPointLocation, on: self)
    }
    
    // MARK: Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets.indices, id: \.self) { i in
                        if i > 0 {
                            Spacer().frame(minWidth: 0, maxWidth: 500)
                        }
                        VStack {
                            if self.chartStyle.xAxisLabelPosition == .bottom {
                                RotatedText(chartData: self, label: self.dataSets.dataSets[i].setTitle, rotation: angle)
                                Spacer()
                            } else {
                                Spacer()
                                RotatedText(chartData: self, label: self.dataSets.dataSets[i].setTitle, rotation: angle)
                            }
                        }
                        .frame(width: self.getXSectionForDataPoint(dataSet: self.dataSets, chartSize: self.viewData.chartSize, groupSpacing: self.groupSpacing),
                               height: self.viewData.xAxisLabelHeights.max())
                        if i < self.dataSets.dataSets.count - 1 {
                            Spacer().frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            if i > 0 {
                                Spacer().frame(minWidth: 0, maxWidth: 500)
                            }
                            VStack {
                                if self.chartStyle.xAxisLabelPosition == .bottom {
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                    Spacer()
                                } else {
                                    Spacer()
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                }
                            }
                            .frame(width: self.viewData.xAxislabelWidths.max(),
                                   height: self.viewData.xAxisLabelHeights.max())
                            if i < labelArray.count - 1 {
                                Spacer().frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func getXSectionForDataPoint(dataSet: GroupedBarDataSets, chartSize: CGRect, groupSpacing: CGFloat) -> CGFloat {
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        let section = superXSection - compensation
        return section > 0 ? section : 0
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        // Divide the chart into equal sections.
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSets.dataSets.count))
        let superIndex: Int = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection: CGFloat = superXSection - compensation
        let ySection: CGFloat = chartSize.height / CGFloat(self.maxValue)
        
        let index: Int = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)
        
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
                touchedDataPointPublisher.send(PublishedTouchData<GroupedBarDataPoint>(datapoint: datapoint, location: location))
            }
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(position: touchPointLocation)
    }
    
    public typealias SetType = GroupedBarDataSets
    public typealias DataPoint = GroupedBarDataPoint
    public typealias CTStyle = BarChartStyle
}
