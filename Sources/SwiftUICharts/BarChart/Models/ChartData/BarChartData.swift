//
//  BarChartData.swift
//
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a standard Bar Chart.
 */
public final class BarChartData: CTBarChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public final var dataSets: BarDataSet
    @Published public final var metadata: ChartMetadata
    @Published public final var xAxisLabels: [String]?
    @Published public final var yAxisLabels: [String]?
    @Published public final var barStyle: BarStyle
    @Published public final var chartStyle: BarChartStyle
    @Published public final var legends: [LegendData]
    @Published public final var viewData: ChartViewData
    @Published public final var infoView: InfoViewData<BarChartDataPoint> = InfoViewData()
    
    @Published public final var extraLineData: ExtraLineData?
    
    // Publishable
    public var subscription = SubscriptionSet().subscription
    public let touchedDataPointPublisher = PassthroughSubject<DataPoint,Never>()
    
    public final var noDataText: Text
    public final let chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public var disableAnimation = false
    
    // MARK: Initializer
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
    public init(
        dataSets: BarDataSet,
        metadata: ChartMetadata = ChartMetadata(),
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
        self.noDataText = noDataText
        
        self.legends = [LegendData]()
        self.viewData = ChartViewData()
        self.chartType = (.bar, .single)
        self.setupLegends()
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints, id: \.id) { data in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        VStack {
                            if self.chartStyle.xAxisLabelPosition == .bottom {
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                                Spacer()
                            } else {
                                Spacer()
                                RotatedText(chartData: self, label: data.wrappedXAxisLabel, rotation: angle)
                            }
                        }
                        .frame(width: self.getXSection(dataSet: self.dataSets, chartSize: self.viewData.chartSize),
                               height: self.viewData.xAxisLabelHeights.max())
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
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
                            .frame(width: self.viewData.xAxislabelWidths.max(),
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
    private final func getXSection(dataSet: BarDataSet, chartSize: CGRect) -> CGFloat {
        chartSize.width.divide(by: dataSet.dataPoints.count)
    }
    
    
    // MARK: - Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            self.markerSubView()
            self.extraLineData?.getTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
        }
    }
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            dataSets.dataPoints[index].legendTag = dataSets.legendTitle
            self.infoView.touchOverlayInfo = [dataSets.dataPoints[index]]
            if let data = self.extraLineData,
               let point = data.getDataPoint(touchLocation: touchLocation, chartSize: chartSize) {
                var dp = BarChartDataPoint(value: point.value, description: point.pointDescription)
                dp.legendTag = data.legendTitle
                self.infoView.touchOverlayInfo.append(dp)
            }
            touchedDataPointPublisher.send(dataSets.dataPoints[index])
        }
    }
    
    public final func getPointLocation(dataSet: BarDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count)
        var ySection: CGFloat = chartSize.height / CGFloat(self.maxValue)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSet.dataPoints.count {
            let x = (CGFloat(index) * xSection) + (xSection / 2)
            var y = (chartSize.size.height - CGFloat(dataSet.dataPoints[index].value) * ySection)
            if self.minValue.isLess(than: 0) {
                ySection = chartSize.height / (CGFloat(self.maxValue) - CGFloat(self.minValue))
                y = (chartSize.size.height - (CGFloat(dataSet.dataPoints[index].value) * ySection) + (CGFloat(self.minValue) * ySection))
            }
            return CGPoint(x: x,
                           y: y)
        }
        return nil
    }
    
    public typealias SetType = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle = BarChartStyle
}
