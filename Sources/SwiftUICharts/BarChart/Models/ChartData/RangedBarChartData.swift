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
@available(macOS 11.0, iOS 13, watchOS 7, tvOS 14, *)
public final class RangedBarChartData: CTRangedBarChartDataProtocol, ChartConformance {
    // MARK: Properties
    public let id: UUID = UUID()
    
    @Published public var dataSets: RangedBarDataSet
    @Published public var metadata: ChartMetadata
    @Published public var xAxisLabels: [String]?
    @Published public var yAxisLabels: [String]?
    @Published public var barStyle: BarStyle
    @Published public var chartStyle: BarChartStyle
    
    @Published public var legends: [LegendData] = []
    @Published public var viewData: ChartViewData = ChartViewData()
    @Published public var infoView: InfoViewData<RangedBarDataPoint> = InfoViewData()
    @Published public var extraLineData: ExtraLineData!
    
    public var noDataText: Text
    
    public var subscription = Set<AnyCancellable>()
    public let touchedDataPointPublisher = PassthroughSubject<PublishedTouchData<RangedBarDataPoint>,Never>()
    
    internal let chartType: (chartType: ChartType, dataSetType: DataSetType) = (.bar, .single)
    
    private var internalSubscription: AnyCancellable?
    private var touchPointLocation: CGPoint = .zero
    
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
        
        self.setupLegends()
        self.setupInternalCombine()
    }
    
    private func setupInternalCombine() {
        internalSubscription = touchedDataPointPublisher
            .map(\.location)
            .assign(to: \.touchPointLocation, on: self)
    }
    
    public var average: Double {
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
    private func getXSection(dataSet: RangedBarDataSet, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
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
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            let datapoint = dataSets.dataPoints[index]
            let value = CGFloat((dataSets.dataPoints[index].upperValue + dataSets.dataPoints[index].lowerValue) / 2) - CGFloat(self.minValue)
            let location = CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                           y: (chartSize.size.height - (value / CGFloat(self.range)) * chartSize.size.height))
            
            touchedDataPointPublisher.send(PublishedTouchData(datapoint: datapoint, location: location))
        }
    }
    
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(position: touchPointLocation)
    }
    
    public typealias SetType = RangedBarDataSet
    public typealias DataPoint = RangedBarDataPoint
    public typealias CTStyle = BarChartStyle
}


extension RangedBarChartData {
    func getBarPositionX(dataPoint: RangedBarDataPoint, height: CGFloat) -> CGFloat {
        let value = CGFloat((dataPoint.upperValue + dataPoint.lowerValue) / 2) - CGFloat(self.minValue)
        return (height - (value / CGFloat(self.range)) * height)
    }
}
