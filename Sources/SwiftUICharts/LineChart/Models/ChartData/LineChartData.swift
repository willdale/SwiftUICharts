//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a single line, line chart.
 
 This model contains the data and styling information for a single line, line chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class LineChartData: CTLineChartDataProtocol, ChartConformance {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: LineDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var chartStyle: LineChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
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
        
    // MARK: Initializer
    /// Initialises a Single Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: LineDataSet,
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
            .sink {
                let lineMarkerData: [LineMarkerData] = $0.compactMap { data in
                    if data.type == .extraLine,
                       let extraData = self.extraLineData {
                        return LineMarkerData(markerType: extraData.style.markerType,
                                              location: data.location,
                                              dataPoints: extraData.dataPoints.map { LineChartDataPoint($0) },
                                              lineType: extraData.style.lineType,
                                              lineSpacing: extraData.style.lineSpacing,
                                              minValue: extraData.minValue,
                                              range: extraData.range)
                    } else if data.type == .line {
                        return LineMarkerData(markerType: self.chartStyle.markerType,
                                              location: data.location,
                                              dataPoints: self.dataSets.dataPoints,
                                              lineType: self.dataSets.style.lineType,
                                              lineSpacing: .line,
                                              minValue: self.minValue,
                                              range: self.range)
                    }
                    return nil
                }
                self.markerData =  MarkerData(lineMarkerData: lineMarkerData, barMarkerData: [])
                self.touchPointData = $0.map(\.datapoint)
            }
    }
    
    // MARK: Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                GeometryReader { geo in
                    ZStack {
                        ForEach(self.dataSets.dataPoints.indices) { i in
                            if let label = self.dataSets.dataPoints[i].xAxisLabel {
                                if label != "" {
                                    TempText(chartData: self, label: label, rotation: angle)
                                        .frame(width: min(self.getXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize), self.viewData.xAxislabelWidths.min() ?? 0),
                                               height: self.viewData.xAxisLabelHeights.max() ?? 0)
                                        .offset(x: CGFloat(i) * (geo.frame(in: .local).width / CGFloat(self.dataSets.dataPoints.count - 1)),
                                                y: 0)
                                }
                            }
                        }
                    }
                }
                .frame(height: self.viewData.xAxisLabelHeights.max())
                
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
                            .frame(width: self.viewData.xAxislabelWidths.min(),
                                   height: self.viewData.xAxisLabelHeights.max())
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
        PointsSubView(chartData: self,
                      dataSets: dataSets,
                      minValue: minValue,
                      range: range,
                      animation: chartStyle.globalAnimation)
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

        let xSection = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection = chartSize.height / CGFloat(range)

        let index = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let location = CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(datapoint.value - minValue) * -ySection) + chartSize.height)
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: chartType.chartType))

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
    
    public typealias SetType = LineDataSet
    public typealias DataPoint = LineChartDataPoint
    
    // MARK: Deprecated
    /// Initialises a Single Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    @available(*, deprecated, message: "Please set use other init instead.")
    public init(
        dataSets: LineDataSet,
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

//extension Collection where Element: Ignorable {
//    var firstNonIgnored: Element? {
//        self.first(where: { !$0.ignore } )
//    }
//    var lastNonIgnored: Element? {
//        self.lastIndex(where: { !$0.ignore })
//    }
//}
