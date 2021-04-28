//
//  HorizontalBarChartData.swift
//  
//
//  Created by Will Dale on 26/04/2021.
//

import SwiftUI

/**
 Data for drawing and styling a standard Bar Chart.
 */
public final class HorizontalBarChartData: CTHorizontalBarChartDataProtocol {
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
        let ySection: CGFloat = chartSize.height / CGFloat(dataSet.dataPoints.count)
        let xSection: CGFloat = chartSize.width / CGFloat(self.maxValue)
        let index: Int = Int((touchLocation.y) / ySection)
        if index >= 0 && index < dataSet.dataPoints.count {
            return CGPoint(x: (CGFloat(dataSet.dataPoints[index].value) * xSection),
                           y: (CGFloat(index) * ySection) + (ySection / 2))
        }
        return nil
    }
    
    public typealias Set = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle = BarChartStyle
}
