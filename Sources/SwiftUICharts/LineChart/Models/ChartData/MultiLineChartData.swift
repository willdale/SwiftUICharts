//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a multi line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class MultiLineChartData: CTLineChartDataProtocol, StandardChartConformance, ChartAxes, ViewDataProtocol {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: MultiLineDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var chartStyle: LineChartStyle
    @Published public var legends: [LegendData] = []
    
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var xAxisViewData = XAxisViewData()
    @Published public var yAxisViewData = YAxisViewData()
    
    @Published public var infoView: InfoViewData<LineChartDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    @Published public var shouldAnimate: Bool
        
    public var noDataText: Text
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (chartType: .line, dataSetType: .single)
    
    public let touchedDataPointPublisher = PassthroughSubject<[PublishedTouchData<DataPoint>], Never>()
    
    private var internalSubscription: AnyCancellable?
    private var markerData: MarkerData = MarkerData()
    private var internalDataSubscription: AnyCancellable?
    @Published public var touchPointData: [DataPoint] = []
    
    // MARK: Initializers
    /// Initialises a Multi Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: MultiLineDataSet,
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        chartStyle: LineChartStyle = LineChartStyle(),
        shouldAnimate: Bool = true,
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.chartStyle = chartStyle
        self.shouldAnimate = shouldAnimate
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
    
    private func setupInternalCombine() {
        internalSubscription = touchedDataPointPublisher
            .sink { published in
                var lineMarkerData: [LineMarkerData] = []
                published.forEach { data in
                    if data.type == .extraLine,
                       let extraData = self.extraLineData {
                        let extraLineMarkerData = LineMarkerData(markerType: extraData.style.markerType,
                                                                 location: data.location,
                                                                 dataPoints: extraData.dataPoints.map { LineChartDataPoint($0) },
                                                                 lineType: extraData.style.lineType,
                                                                 lineSpacing: .bar,
                                                                 minValue: extraData.minValue,
                                                                 range: extraData.range)
                        lineMarkerData.append(extraLineMarkerData)
                    } else if data.type == .line {
                        let location = data.location
                        let lineData = self.dataSets.dataSets.compactMap { dataSet in
                            return LineMarkerData(markerType: self.chartStyle.markerType,
                                                  location: location,
                                                  dataPoints: dataSet.dataPoints,
                                                  lineType: dataSet.style.lineType,
                                                  lineSpacing: .line,
                                                  minValue: self.minValue,
                                                  range: self.range)
                        }
                        lineMarkerData.append(contentsOf: lineData)
                    }
                }
                self.markerData =  MarkerData(lineMarkerData: lineMarkerData, barMarkerData: [])
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
                    ForEach(dataSets.dataSets[0].dataPoints) { data in
                        VStack {
                            if self.chartStyle.xAxisLabelPosition == .bottom {
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                                Spacer()
                            } else {
                                Spacer()
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                            }
                        }
                        .frame(width: min(self.getXSection(dataSet: self.dataSets.dataSets[0], chartSize: self.viewData.chartSize),
                                          self.xAxisViewData.xAxislabelWidths.min() ?? 0),
                               height: self.xAxisViewData.xAxisLabelHeights.max())
                        if data != self.dataSets.dataSets[0].dataPoints[self.dataSets.dataSets[0].dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
                
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { i in
                            VStack {
                                if self.chartStyle.xAxisLabelPosition == .bottom {
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                    Spacer()
                                } else {
                                    Spacer()
                                    RotatedText(chartData: self, label: labelArray[i], rotation: angle)
                                }
                            }
                            .frame(width: self.xAxisViewData.xAxislabelWidths.min(),
                                   height: self.xAxisViewData.xAxisLabelHeights.max())
                            if i != labelArray.count - 1 {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }
    private func getXSection(dataSet: LineDataSet, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
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
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
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
        
        touchedDataPointPublisher.send(values)
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        markerSubView(markerData: markerData,
                      chartSize: chartSize,
                      touchLocation: touchLocation)
    }
    
    public func touchDidFinish() {
        touchPointData = []
        infoView.isTouchCurrent = false
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
    public typealias CTStyle = LineChartStyle
    
    // MARK: Deprecated
    /// Initialises a Multi Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: MultiLineDataSet,
        metadata: ChartMetadata,
        xAxisLabels: [String]? = nil,
        yAxisLabels: [String]? = nil,
        chartStyle: LineChartStyle = LineChartStyle(),
        noDataText: Text = Text("No Data")
    ) {
        self.dataSets = dataSets
        self.metadata = metadata
        self.xAxisLabels = xAxisLabels
        self.yAxisLabels = yAxisLabels
        self.chartStyle = chartStyle
        self.shouldAnimate = true
        self.noDataText = noDataText
        
        self.setupLegends()
        self.setupInternalCombine()
    }
}
