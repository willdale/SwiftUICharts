//
//  BarChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a standard Bar Chart.
 */
public final class BarChartData: CTBarChartDataProtocol {
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
    
    @Published public final var extraLineData: ExtraLineData!
    
    public final var noDataText: Text
    public final let chartType: (chartType: ChartType, dataSetType: DataSetType)
    
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
        self.markerSubView()
    }
    
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            dataSets.dataPoints[index].legendTag = dataSets.legendTitle
            self.infoView.touchOverlayInfo = [dataSets.dataPoints[index]]
        }
    }
    
    public final func getPointLocation(dataSet: BarDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let xSection: CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count)
        let ySection: CGFloat = chartSize.height / CGFloat(self.maxValue)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSet.dataPoints.count {
            return CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                           y: (chartSize.size.height - CGFloat(dataSet.dataPoints[index].value) * ySection))
        }
        return nil
    }
    
    public typealias Set = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle = BarChartStyle
}
