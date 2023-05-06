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
public final class MultiLineChartData: CTLineChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public final var dataSets: MultiLineDataSet
    @Published public final var metadata: ChartMetadata
    @Published public final var xAxisLabels: [String]?
    @Published public final var yAxisLabels: [String]?
    @Published public final var chartStyle: LineChartStyle
    @Published public final var legends: [LegendData]
    @Published public final var viewData: ChartViewData
    @Published public final var infoView: InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public final var noDataText: Text
    public final var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    @Published public final var extraLineData: ExtraLineData?
    
    // Publishable
    public var subscription = SubscriptionSet().subscription
    public let touchedDataPointPublisher = PassthroughSubject<DataPoint,Never>()
    
    public var disableAnimation = false
    
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
        self.legends = [LegendData]()
        self.viewData = ChartViewData()
        self.chartType = (.line, .multi)
        self.setupLegends()
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
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
    private final func getXSection(dataSet: LineDataSet, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
    }
    
    // MARK: Points
    public final func getPointMarker() -> some View {
        ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
            PointsSubView(dataSets: dataSet,
                          minValue: self.minValue,
                          range: self.range,
                          animation: self.chartStyle.globalAnimation,
                          isFilled: false,
                          disableAnimation: self.disableAnimation)
        }
    }
    
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
                self.markerSubView(dataSet: dataSet,
                                   dataPoints: dataSet.dataPoints,
                                   lineType: dataSet.style.lineType,
                                   touchLocation: touchLocation,
                                   chartSize: chartSize)
            }
            self.extraLineData?.getTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
        }
    }
    
    // MARK: Accessibility
    public func getAccessibility() -> some View {
        ForEach(self.dataSets.dataSets, id: \.self) { dataSet in
            ForEach(dataSet.dataPoints.indices, id: \.self) { point in
                AccessibilityRectangle(dataPointCount: dataSet.dataPoints.count,
                                       dataPointNo: point)
                    .foregroundColor(Color(.gray).opacity(0.000000001))
                    .accessibilityLabel(LocalizedStringKey(self.metadata.title))
                    .accessibilityValue(dataSet.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier,
                                                                                            formatter: self.infoView.touchFormatter))
            }
        }
    }
    
    public typealias SetType = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
    public typealias CTStyle = LineChartStyle
}


// MARK: - Touch
extension MultiLineChartData {
    public func getPointLocation(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let minValue: Double = self.minValue
        let range: Double = self.range
        let xSection: CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
        let ySection: CGFloat = chartSize.height / CGFloat(range)
        let index: Int = Int((touchLocation.x + (xSection / 2)) / xSection)
        
        if index >= 0 && index < dataSet.dataPoints.count {
            if !dataSet.style.ignoreZero {
                return CGPoint(x: CGFloat(index) * xSection,
                               y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
            } else {
                if dataSet.dataPoints[index].value != 0 {
                    return CGPoint(x: CGFloat(index) * xSection,
                                   y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.height)
                }
            }
        }
        return nil
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.touchOverlayInfo = dataSets.dataSets.indices.compactMap { setIndex in
            let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataSets[setIndex].dataPoints.count - 1)
            let index = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSets.dataSets[setIndex].dataPoints.count {
                if let data = self.extraLineData,
                   let point = data.getDataPoint(touchLocation: touchLocation, chartSize: chartSize) {
                    var dp = LineChartDataPoint(value: point.value, xAxisLabel: point.pointDescription, description: point.pointDescription)
                    dp.legendTag = data.legendTitle
                    self.infoView.touchOverlayInfo.append(dp)
                }
                touchedDataPointPublisher.send(dataSets.dataSets[setIndex].dataPoints[index])
                if !dataSets.dataSets[setIndex].style.ignoreZero {
                    dataSets.dataSets[setIndex].dataPoints[index].legendTag = dataSets.dataSets[setIndex].legendTitle
                    return dataSets.dataSets[setIndex].dataPoints[index]
                } else {
                    if dataSets.dataSets[setIndex].dataPoints[index].value != 0 {
                        dataSets.dataSets[setIndex].dataPoints[index].legendTag = dataSets.dataSets[setIndex].legendTitle
                        return dataSets.dataSets[setIndex].dataPoints[index]
                    } else {
                        dataSets.dataSets[setIndex].dataPoints[index].legendTag = dataSets.dataSets[setIndex].legendTitle
                        dataSets.dataSets[setIndex].dataPoints[index].ignoreMe = true
                        return dataSets.dataSets[setIndex].dataPoints[index]
                    }
                }
            }
            return nil
        }
    }
}
