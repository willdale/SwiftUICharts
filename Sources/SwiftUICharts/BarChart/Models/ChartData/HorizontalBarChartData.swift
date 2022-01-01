//
//  HorizontalBarChartData.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a standard Bar Chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class HorizontalBarChartData: CTHorizontalBarChartDataProtocol, ChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: BarDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var barStyle: BarStyle
    @Published public var chartStyle: BarChartStyle
    
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<BarChartDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!

    @Published public var shouldAnimate: Bool
        
    public var noDataText: Text
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (.bar, .single)

    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<DataPoint>], Never>()

    private var internalSubscription: AnyCancellable?
    private var markerData: MarkerData = MarkerData()
    private var internalDataSubscription: AnyCancellable?
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Initializer
    /// Initialises a standard Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: BarDataSet,
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        chartStyle: BarChartStyle = BarChartStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.chartStyle = chartStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        
        self.setupLegends()
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
                        return BarMarkerData(markerType: self.chartStyle.markerType,
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
        HStack(spacing: 0) {
            ForEach(self.labelsArray.indices, id: \.self) { i in
                Text(LocalizedStringKey(self.labelsArray[i]))
                    .font(self.chartStyle.yAxisLabelFont)
                    .foregroundColor(self.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
                    .accessibilityValue(LocalizedStringKey(self.labelsArray[i]))
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear {
                                    self.viewData.xAxisLabelHeights.append(geo.size.height)
                                }
                        }
                    )
                if i != self.labelsArray.count - 1 {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
    }
    
    public func getYAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:
                
                VStack {
                    if self.chartStyle.xAxisLabelPosition == .top {
                        Spacer()
                            .frame(height: yAxisPaddingHeight + 8) // Why 8 ?
                    }
                    ForEach(dataSets.dataPoints, id: \.id) { data in
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                        HStack(spacing: 0) {
                            if self.chartStyle.yAxisLabelPosition == .leading {
                                Spacer()
                                HorizontalRotatedText(chartData: self, label: data.wrappedXAxisLabel)
                            } else {
                                HorizontalRotatedText(chartData: self, label: data.wrappedXAxisLabel)
                                Spacer()
                            }
                        }
                        .frame(width: self.viewData.yAxisLabelWidth.max())
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                    }
                    if self.chartStyle.xAxisLabelPosition == .bottom {
                        Spacer()
                            .frame(height: yAxisPaddingHeight + 8) // Why 8 ?
                    }
                }
                
            case .chartData:
                
                if let labelArray = self.xAxisLabels {
                    VStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Spacer()
                                .frame(minHeight: 0, maxHeight: 500)
                            Text(LocalizedStringKey(data))
                                .font(self.chartStyle.xAxisLabelFont)
                                .lineLimit(1)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .overlay(
                                    GeometryReader { geo in
                                        Rectangle()
                                            .foregroundColor(Color.clear)
                                            .onAppear {
                                                self.viewData.yAxisLabelWidth.append(geo.size.width)
                                            }
                                    }
                                )
                                .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
                                .accessibilityValue(LocalizedStringKey(data))
                            
                            Spacer()
                                .frame(minHeight: 0, maxHeight: 500)
                        }
                        Spacer()
                            .frame(height: yAxisPaddingHeight + 8) // Why 8 ?
                    }
                    .frame(width: self.viewData.yAxisLabelWidth.max())
                }
            }
        }
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let ySection: CGFloat = chartSize.height / CGFloat(dataSets.dataPoints.count)
        let xSection: CGFloat = chartSize.width / CGFloat(self.maxValue)
        let index: Int = Int((touchLocation.y) / ySection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let location = CGPoint(x: (CGFloat(dataSets.dataPoints[index].value) * xSection),
                                   y: (CGFloat(index) * ySection) + (ySection / 2))
            
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
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        markerSubView(markerData: markerData, touchLocation: touchLocation, chartSize: chartSize)
    }

    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
    }
    
    public typealias SetType = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle = BarChartStyle
    
    // MARK: Deprecated
    /// Initialises a standard Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: BarDataSet,
        metadata: ChartMetadata,
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        barStyle: BarStyle = BarStyle(),
        chartStyle: BarChartStyle = BarChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.metadata = metadata
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.barStyle = barStyle
        self.chartStyle = chartStyle
        self.shouldAnimate = true
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
}
