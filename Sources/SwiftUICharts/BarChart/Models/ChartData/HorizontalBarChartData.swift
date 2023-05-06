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
public final class HorizontalBarChartData: CTHorizontalBarChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
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
    
    public final func getYAxisLabels() -> some View {
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
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            self.markerSubView()
            self.extraLineData?.getTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
        }
    }
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let ySection: CGFloat = chartSize.height / CGFloat(dataSets.dataPoints.count)
        let index: Int = Int((touchLocation.y) / ySection)
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
        let ySection: CGFloat = chartSize.height / CGFloat(dataSet.dataPoints.count)
        var xSection: CGFloat = chartSize.width / CGFloat(self.maxValue)
        let index: Int = Int((touchLocation.y) / ySection)
        if index >= 0 && index < dataSet.dataPoints.count {
            var x = (CGFloat(dataSet.dataPoints[index].value) * xSection)
            let y = (CGFloat(index) * ySection) + (ySection / 2)
            if self.minValue.isLess(than: 0) {
                xSection = chartSize.width / (CGFloat(self.maxValue) - CGFloat(self.minValue))
                x = (CGFloat(dataSet.dataPoints[index].value) * xSection) - (CGFloat(self.minValue) * xSection)
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
