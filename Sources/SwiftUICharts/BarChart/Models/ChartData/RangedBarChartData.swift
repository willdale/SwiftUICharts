//
//  RangedBarChartData.swift
//  
//
//  Created by Will Dale on 03/03/2021.
//

import SwiftUI
import Combine

/**
 Data for drawing and styling a ranged Bar Chart.
 */
public final class RangedBarChartData: CTRangedBarChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public final var dataSets: RangedBarDataSet
    @Published public final var metadata: ChartMetadata
    @Published public final var xAxisLabels: [String]?
    @Published public final var yAxisLabels: [String]?
    @Published public final var barStyle: BarStyle
    @Published public final var chartStyle: BarChartStyle
    @Published public final var legends: [LegendData]
    @Published public final var viewData: ChartViewData
    @Published public final var infoView: InfoViewData<RangedBarDataPoint> = InfoViewData()
    
    @Published public final var extraLineData: ExtraLineData?
    
    // Publishable
    public var subscription = SubscriptionSet().subscription
    public let touchedDataPointPublisher = PassthroughSubject<DataPoint,Never>()
    
    public final var noDataText: Text
    public final let chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public var disableAnimation = false
    
    // MARK: Initializer
    /// Initialises a Ranged Bar Chart.
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
        dataSets: RangedBarDataSet,
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
    
    public final var average: Double {
        let upperAverage = dataSets.dataPoints
            .map(\.upperValue)
            .reduce(0, +)
            .divide(by: Double(dataSets.dataPoints.count))
        let lowerAverage = dataSets.dataPoints
            .map(\.lowerValue)
            .reduce(0, +)
            .divide(by: Double(dataSets.dataPoints.count))
        return (upperAverage + lowerAverage) / 2
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                GeometryReader { geo in
                    ZStack {
                        ForEach(self.dataSets.dataPoints.indices, id: \.self) { i in
                            if let label = self.dataSets.dataPoints[i].xAxisLabel {
                                if label != "" {
                                    TempText(chartData: self, label: label, rotation: angle)
                                        .frame(width: self.getXSection(dataSet: self.dataSets, chartSize: geo.frame(in: .local)),
                                               height: self.viewData.xAxisLabelHeights.max() ?? 0)
                                        .offset(x: CGFloat(i) * (geo.frame(in: .local).width / CGFloat(self.dataSets.dataPoints.count)),
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
    private final func getXSection(dataSet: RangedBarDataSet, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
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
                var dp = RangedBarDataPoint(lowerValue: point.value, upperValue: point.value, description: point.pointDescription)
                dp.legendTag = data.legendTitle
                dp._value = point.value
                self.infoView.touchOverlayInfo.append(dp)
            }
            touchedDataPointPublisher.send(dataSets.dataPoints[index])
        }
    }
    
    public final func getPointLocation(dataSet: RangedBarDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSet.dataPoints.count {
            let value = CGFloat((dataSet.dataPoints[index].upperValue + dataSet.dataPoints[index].lowerValue) / 2) - CGFloat(self.minValue)
            return CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                           y: (chartSize.size.height - (value / CGFloat(self.range)) * chartSize.size.height))
        }
        return nil
    }
    
    public typealias SetType = RangedBarDataSet
    public typealias DataPoint = RangedBarDataPoint
    public typealias CTStyle = BarChartStyle
}


extension RangedBarChartData {
    final func getBarPositionX(dataPoint: RangedBarDataPoint, height: CGFloat) -> CGFloat {
        let value = CGFloat((dataPoint.upperValue + dataPoint.lowerValue) / 2) - CGFloat(self.minValue)
        return (height - (value / CGFloat(self.range)) * height)
    }
}
