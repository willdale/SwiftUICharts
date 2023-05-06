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
public final class LineChartData: CTLineChartDataProtocol, GetDataProtocol, Publishable, PointOfInterestProtocol {
    
    // MARK: Properties
    public final let id: UUID = UUID()
    
    @Published public final var dataSets: LineDataSet
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
    
    internal final var isFilled: Bool = false
    
    // MARK: Initializer
    /// Initialises a Single Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(
        dataSets: LineDataSet,
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
        self.chartType = (chartType: .line, dataSetType: .single)
        self.setupLegends()
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                ZStack {
                    ForEach(self.dataSets.dataPoints.indices, id: \.self) { i in                                                     
                        GeometryReader { geo in
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
    private final func getXSection(dataSet: LineDataSet, chartSize: CGRect) -> CGFloat {
         chartSize.width / CGFloat(dataSet.dataPoints.count)
    }
    
    // MARK: Points
    public final func getPointMarker() -> some View {
        PointsSubView(dataSets: dataSets,
                      minValue: self.minValue,
                      range: self.range,
                      animation: self.chartStyle.globalAnimation,
                      isFilled: self.isFilled,
                      disableAnimation: disableAnimation)
    }
    
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        ZStack {
            self.markerSubView(dataSet: dataSets,
                               dataPoints: dataSets.dataPoints,
                               lineType: dataSets.style.lineType,
                               touchLocation: touchLocation,
                               chartSize: chartSize)
            self.extraLineData?.getTouchInteraction(touchLocation: touchLocation, chartSize: chartSize)
        }
    }
    
    public typealias SetType = LineDataSet
    public typealias DataPoint = LineChartDataPoint
}

// MARK: - Touch
extension LineChartData {
    
    public final func getPointLocation(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
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
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let index: Int = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            if !dataSets.style.ignoreZero {
                dataSets.dataPoints[index].legendTag = dataSets.legendTitle
                self.infoView.touchOverlayInfo = [dataSets.dataPoints[index]]
            } else {
                if dataSets.dataPoints[index].value != 0 {
                    dataSets.dataPoints[index].legendTag = dataSets.legendTitle
                    self.infoView.touchOverlayInfo = [dataSets.dataPoints[index]]
                } else {
                    dataSets.dataPoints[index].legendTag = dataSets.legendTitle
                    dataSets.dataPoints[index].ignoreMe = true
                    self.infoView.touchOverlayInfo = [dataSets.dataPoints[index]]
                }
            }
            if let data = self.extraLineData,
               let point = data.getDataPoint(touchLocation: touchLocation, chartSize: chartSize) {
                var dp = LineChartDataPoint(value: point.value, description: point.pointDescription)
                dp.legendTag = data.legendTitle
                self.infoView.touchOverlayInfo.append(dp)
            }
            touchedDataPointPublisher.send(dataSets.dataPoints[index])
        }
    }
}
