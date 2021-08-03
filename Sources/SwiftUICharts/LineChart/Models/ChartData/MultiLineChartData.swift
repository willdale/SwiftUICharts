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
@available(macOS 11.0, iOS 13, watchOS 7, tvOS 14, *)
public final class MultiLineChartData: CTLineChartDataProtocol, ChartConformance {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public var dataSets: MultiLineDataSet
    @Published public var metadata: ChartMetadata
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var chartStyle: LineChartStyle
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<LineChartDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    public var noDataText: Text

    public var subscription = Set<AnyCancellable>()
    public let touchedDataPointPublisher = PassthroughSubject<PublishedTouchData<LineChartDataPoint>,Never>()

    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (.line, .multi)
   
    private var internalSubscription: AnyCancellable?
    private var touchPointLocation: CGPoint = .zero
    
    // MARK: Initializers
    /// Initialises a Multi Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the lines.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: MultiLineDataSet,
        metadata: ChartMetadata = ChartMetadata(),
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
                        .frame(width: min(self.getXSection(dataSet: self.dataSets.dataSets[0], chartSize: self.viewData.chartSize), self.viewData.xAxislabelWidths.min() ?? 0),
                               height: self.viewData.xAxisLabelHeights.max())
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
        ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
            PointsSubView(dataSets: dataSet,
                          minValue: self.minValue,
                          range: self.range,
                          animation: self.chartStyle.globalAnimation,
                          isFilled: false)
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
        let data: [(LineChartDataPoint, CGPoint)] = dataSets.dataSets.compactMap { dataSet in
            let xSection: CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection: CGFloat = chartSize.height / CGFloat(range)
            let index = Int((touchLocation.x + (xSection / 2)) / xSection)
            
            var location: CGPoint = .zero
            var datapoint: LineChartDataPoint = LineChartDataPoint(value: 0)
            
            if index >= 0 && index < dataSet.dataPoints.count {
                
                if !dataSet.style.ignoreZero {
                    location = CGPoint(x: CGFloat(index) * xSection,
                                      y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                    datapoint = dataSet.dataPoints[index]
                } else {
                    if dataSet.dataPoints[index].value != 0 {
                        location = CGPoint(x: CGFloat(index) * xSection,
                                      y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                        datapoint = dataSet.dataPoints[index]
                       
                    }
                }
            }
            return (datapoint, location)
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
                self.markerSubView(dataSet: dataSet,
                                   dataPoints: dataSet.dataPoints,
                                   lineType: dataSet.style.lineType,
                                   touchLocation: touchLocation,
                                   chartSize: chartSize,
                                   pointLocation: self.touchPointLocation)
            }
        }
    }
    
    // MARK: Accessibility
    public func getAccessibility() -> some View {
        ForEach(self.dataSets.dataSets, id: \.self) { dataSet in
            ForEach(dataSet.dataPoints.indices, id: \.self) { point in
                AccessibilityRectangle(dataPointCount: dataSet.dataPoints.count,
                                       dataPointNo: point)
                    .foregroundColor(Color(.gray).opacity(0.000000001))
                    .accessibilityLabel(Text("\(self.metadata.title)"))
                    .accessibilityValue(dataSet.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
            }
        }
    }
    
    public typealias SetType = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias CTStyle = LineChartStyle
}
