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
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class GroupedBarChartData: BarChartType, CTChartData, CTMultiBarChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    @Published public var dataSets: GroupedBarDataSets
    @Published public var barStyle: BarStyle
    @Published public var legends: [LegendData] = []
    @Published public var infoView = InfoViewData<GroupedBarDataPoint>()
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
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<DataPoint>], Never>()

    // MARK: Touchable
    public var touchMarkerType: BarMarkerType = defualtTouchMarker
    
    // MARK: DataHelper
    public var baseline: Baseline
    public var topLine: Topline
    
    // MARK: ExtraLineDataProtocol
    @Published public var extraLineData: ExtraLineData!
    
    // MARK: Non-Protocol
    @Published public var chartSize: CGRect = .zero
    private var internalSubscription: AnyCancellable?
    private var markerData: MarkerData = MarkerData()
    private var internalDataSubscription: AnyCancellable?
    internal let chartType: CTChartType = (chartType: .bar, dataSetType: .multi)
    
    // MARK: Deprecated
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    @available(*, deprecated, message: "")
    @Published public var chartStyle = BarChartStyle()
    
    // MARK: Initializer
    /// Initialises a Grouped Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
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
        self.setupInternalCombine()
    }
    
    private func setupInternalCombine() {
        internalSubscription = touchedDataPointPublisher
            .sink {
                let lineMarkerData: [LineMarkerData] = $0.compactMap { data in
                    if data.type == .extraLine,
                       let extraData = self.extraLineData {
                        return LineMarkerData(markerType: extraData.style.markerType,
                                              location: data.location,
                                              dataPoints: extraData.dataPoints.map { LineChartDataPoint($0) },
                                              lineType: extraData.style.lineType,
                                              lineSpacing: .bar,
                                              minValue: extraData.minValue,
                                              range: extraData.range)
                    }
                    return nil
                }
                let barMarkerData: [BarMarkerData] = $0.compactMap { data in
                    if data.type == .bar {
                        return BarMarkerData(markerType: self.touchMarkerType,
                                              location: data.location)
                    }
                    return nil
                }
                self.markerData =  MarkerData(lineMarkerData: lineMarkerData,
                                              barMarkerData: barMarkerData)
            }
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
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
                        .frame(width: self.getXSectionForDataPoint(dataSet: self.dataSets, chartSize: self.chartSize, groupSpacing: self.groupSpacing),
                               height: self.xAxisViewData.xAxisLabelHeights.max())
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
                            .frame(width: self.xAxisViewData.xAxislabelWidths.max(),
                                   height: self.xAxisViewData.xAxisLabelHeights.max())
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
                
                var values: [PublishedTouchData<DataPoint>] = []
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
                
                touchedDataPointPublisher.send(values)
            }
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        markerSubView(markerData: markerData, chartSize: chartSize, touchLocation: touchLocation)
    }
    
    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
    }
    
    public typealias SetType = GroupedBarDataSets
    public typealias DataPoint = GroupedBarDataPoint
    public typealias Marker = BarMarkerType
}
