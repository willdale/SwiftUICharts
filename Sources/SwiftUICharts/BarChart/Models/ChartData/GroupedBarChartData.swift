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
public final class GroupedBarChartData: CTMultiBarChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public final var dataSets: GroupedBarDataSets
    @Published public final var metadata: ChartMetadata
    @Published public final var xAxisLabels: [String]?
    @Published public final var yAxisLabels: [String]?
    @Published public final var barStyle: BarStyle
    @Published public final var chartStyle: BarChartStyle
    @Published public final var legends: [LegendData]
    @Published public final var viewData: ChartViewData
    @Published public final var infoView: InfoViewData<GroupedBarDataPoint> = InfoViewData()
    @Published public final var groups: [GroupingData]
    
    @Published public final var extraLineData: ExtraLineData?
    
    // Publishable
    public var subscription = SubscriptionSet().subscription
    public let touchedDataPointPublisher = PassthroughSubject<DataPoint,Never>()
    
    public final var noDataText: Text
    public final var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    final var groupSpacing: CGFloat = 0
    
    public var disableAnimation = false
    
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
        self.legends = [LegendData]()
        self.viewData = ChartViewData()
        self.chartType = (chartType: .bar, dataSetType: .multi)
        self.setupLegends()
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
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
    
    private final func getXSectionForDataPoint(dataSet: GroupedBarDataSets, chartSize: CGRect, groupSpacing: CGFloat) -> CGFloat {
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        let section = superXSection - compensation
        return section > 0 ? section : 0
    }
    
    // MARK: Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            self.markerSubView()
            self.extraLineData?.getTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
        }
    }
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        // Divide the chart into equal sections.
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSets.dataSets.count))
        let superIndex: Int = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection: CGFloat = superXSection - compensation
        let index: Int = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSection)
        
        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            let xSubSection: CGFloat = (xSection / CGFloat(dataSets.dataSets[index].dataPoints.count))
            let subIndex: Int = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSubSection) - (dataSets.dataSets[index].dataPoints.count * index)
            if subIndex >= 0 && subIndex < dataSets.dataSets[index].dataPoints.count {
                dataSets.dataSets[index].dataPoints[subIndex].legendTag = dataSets.dataSets[index].setTitle
                self.infoView.touchOverlayInfo = [dataSets.dataSets[index].dataPoints[subIndex]]
                if let data = self.extraLineData,
                   let point = data.getDataPoint(touchLocation: touchLocation, chartSize: chartSize) {
                    var dp = GroupedBarDataPoint(value: point.value, description: point.pointDescription, group: GroupingData(title: data.legendTitle, colour: ColourStyle()))
                    dp.legendTag = data.legendTitle
                    self.infoView.touchOverlayInfo.append(dp)
                }
                touchedDataPointPublisher.send(dataSets.dataSets[index].dataPoints[subIndex])
            }
        }
    }
    
    public final func getPointLocation(dataSet: GroupedBarDataSets, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        // Divide the chart into equal sections.
        let superXSection: CGFloat = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let superIndex: Int = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation: CGFloat = ((groupSpacing * CGFloat(dataSet.dataSets.count - 1)) / CGFloat(dataSet.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection: CGFloat = superXSection - compensation
        var ySection: CGFloat = chartSize.height / CGFloat(self.maxValue)
        
        let index: Int = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)
        
        if index >= 0 && index < dataSet.dataSets.count && superIndex == index {
            let subDataSet = dataSet.dataSets[index]
            let xSubSection: CGFloat = (xSection / CGFloat(subDataSet.dataPoints.count))
            let subIndex: Int = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(index))) / xSubSection) - (subDataSet.dataPoints.count * index)
            if subIndex >= 0 && subIndex < subDataSet.dataPoints.count {
                let element: CGFloat = (CGFloat(subIndex) * xSubSection) + (xSubSection / 2)
                let section: CGFloat = (superXSection * CGFloat(superIndex))
                let spacing: CGFloat = ((groupSpacing / CGFloat(dataSets.dataSets.count)) * CGFloat(superIndex))
                let x = element + section + spacing
                var y = (chartSize.height - CGFloat(subDataSet.dataPoints[subIndex].value) * ySection)
                if self.minValue.isLess(than: 0) {
                    ySection = chartSize.height / (CGFloat(self.maxValue) - CGFloat(self.minValue))
                    y = (chartSize.height - (CGFloat(subDataSet.dataPoints[subIndex].value) * ySection) + (CGFloat(self.minValue) * ySection))
                }
                return CGPoint(x: x,
                               y: y)
            }
        }
        return nil
    }
    
    public typealias SetType = GroupedBarDataSets
    public typealias DataPoint = GroupedBarDataPoint
    public typealias CTStyle = BarChartStyle
}
