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
@available(macOS 11.0, iOS 13, watchOS 7, tvOS 14, *)
public final class BarChartData: CTBarChartDataProtocol, ChartConformance{
    
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public var dataSets: BarDataSet
    @Published public var metadata: ChartMetadata
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var barStyle: BarStyle
    @Published public var chartStyle: BarChartStyle
    
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<BarChartDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    public var noDataText: Text
    
    public var subscription = Set<AnyCancellable>()
    public let touchedDataPointPublisher = PassthroughSubject<PublishedTouchData<BarChartDataPoint>, Never>()
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (.bar, .single)
    
    private var internalSubscription: AnyCancellable?
    private var touchPointLocation: CGPoint = .zero
    
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
    private func getXSection(dataSet: BarDataSet, chartSize: CGRect) -> CGFloat {
        chartSize.width.divide(by: dataSet.dataPoints.count)
    }
    
    
    // MARK: - Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        self.infoView.isTouchCurrent = true
        self.infoView.touchLocation = touchLocation
        self.infoView.chartSize = chartSize
        self.processTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    private func processTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let ySection: CGFloat = chartSize.height / CGFloat(dataSets.maxValue())
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let data = dataSets.dataPoints[index]
            let location = CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                   y: (chartSize.size.height - CGFloat(dataSets.dataPoints[index].value) * ySection))
            
            touchedDataPointPublisher.send(PublishedTouchData(datapoint: data, location: location))
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(position: touchPointLocation)
    }
    
   
    
    public typealias SetType = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle = BarChartStyle
}


public struct PublishedTouchData<DataPoint> {
    public let datapoint: DataPoint
    public let location: CGPoint
}
