//
//  RangedLineChartData.swift
//  
//
//  Created by Will Dale on 01/03/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling ranged line chart.
 
 This model contains the data and styling information for a ranged line chart.
 */
@available(macOS 11.0, iOS 14, watchOS 7, tvOS 14, *)
public final class RangedLineChartData: CTLineChartDataProtocol, ChartConformance {
    
    // MARK: Properties
    public let id: UUID  = UUID()
    
    public var accessibilityTitle: LocalizedStringKey = ""
    
    @Published public var dataSets: RangedLineDataSet
    
    @available(*, deprecated, message: "Please set the data in \".titleBox\" instead.")
    @Published public var metadata = ChartMetadata()
    
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var chartStyle: LineChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<RangedLineChartDataPoint> = InfoViewData()
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
    /// Initialises a ranged line chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - shouldAnimate: Whether the chart should be animated.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: RangedLineDataSet,
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
        self.setupRangeLegends()
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
                    } else if data.type == .line {
                        return LineMarkerData(markerType: self.chartStyle.markerType,
                                              location: data.location,
                                              dataPoints: self.dataSets.dataPoints.map { LineChartDataPoint($0) },
                                              lineType: self.dataSets.style.lineType,
                                              lineSpacing: .line,
                                              minValue: self.minValue,
                                              range: self.range)
                    }
                    return nil
                }
                self.markerData =  MarkerData(lineMarkerData: lineMarkerData, barMarkerData: [])
            }
        
        internalDataSubscription = touchedDataPointPublisher
            .sink { self.touchPointData = $0.map(\.datapoint) }
    }
    
    public var average: Double {
        dataSets.dataPoints
            .map(\.value)
            .reduce(0, +)
            .divide(by: Double(dataSets.dataPoints.count))
    }
    
    // MARK: Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
                        VStack {
                            if self.chartStyle.xAxisLabelPosition == .bottom {
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                                Spacer()
                            } else {
                                Spacer()
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                            }
                        }
                        .frame(width: min(self.getXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize), self.viewData.xAxislabelWidths.min() ?? 0),
                               height: self.viewData.xAxisLabelHeights.max())
                        if data != self.dataSets.dataPoints[self.dataSets.dataPoints.count - 1] {
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
    private func getXSection(dataSet: RangedLineDataSet, chartSize: CGRect) -> CGFloat {
        chartSize.width.divide(by: CGFloat(dataSet.dataPoints.count))
    }
    
    // MARK: Points
    public func getPointMarker() -> some View {
        PointsSubView(chartData: self,
                      dataSets: dataSets,
                      minValue: self.minValue,
                      range: self.range,
                      animation: self.chartStyle.globalAnimation)
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let xSection = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection = chartSize.height / CGFloat(range)
        let index = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            var values: [PublishedTouchData<DataPoint>] = []
            let datapoint = dataSets.dataPoints[index]
            var location: CGPoint = .zero
            if !dataSets.style.ignoreZero {
                location = CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(dataSets.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
            } else {
                if dataSets.dataPoints[index].value != 0 {
                    location = CGPoint(x: CGFloat(index) * xSection,
                                       y: (CGFloat(dataSets.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                }
            }
            
            values.append(PublishedTouchData(datapoint: datapoint, location: location, type: .line))
            
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
    
    public typealias SetType = RangedLineDataSet
    public typealias DataPoint = RangedLineChartDataPoint
    
    // MARK: Deprecated
    /// Initialises a ranged line chart.
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
        dataSets: RangedLineDataSet,
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
        self.setupRangeLegends()
        self.setupInternalCombine()
    }
}
