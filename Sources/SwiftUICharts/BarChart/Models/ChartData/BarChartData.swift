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
    public let id   : UUID  = UUID()

    @Published public final var dataSets     : BarDataSet
    @Published public final var metadata     : ChartMetadata
    @Published public final var xAxisLabels  : [String]?
    @Published public final var yAxisLabels  : [String]?
    @Published public final var barStyle     : BarStyle
    @Published public final var chartStyle   : BarChartStyle
    @Published public final var legends      : [LegendData]
    @Published public final var viewData     : ChartViewData
    @Published public final var infoView     : InfoViewData<BarChartDataPoint> = InfoViewData()
        
    public final var noDataText   : Text
    public final let chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
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
    public init(dataSets    : BarDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                yAxisLabels : [String]?         = nil,
                barStyle    : BarStyle          = BarStyle(),
                chartStyle  : BarChartStyle     = BarChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.yAxisLabels    = yAxisLabels
        self.barStyle       = barStyle
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.bar, .single)
        self.setupLegends()
    }

    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):

                HStack(alignment: .top, spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        YAxisDataPointCell(chartData: self, label: data.wrappedXAxisLabel, rotationAngle: angle)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .accessibilityLabel(Text("X Axis Label"))
                            .accessibilityValue(Text("\(data.wrappedXAxisLabel)"))
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }

            case .chartData(let angle):
                
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            YAxisDataPointCell(chartData: self, label: data, rotationAngle: angle)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(data)"))
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView()
    }
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        var points      : [BarChartDataPoint] = []
        let xSection    : CGFloat   = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let index       : Int       = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            var dataPoint = dataSets.dataPoints[index]
            dataPoint.legendTag = dataSets.legendTitle
            points.append(dataPoint)
        }
        self.infoView.touchOverlayInfo = points
    }
    public final func getPointLocation(dataSet: BarDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let xSection : CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count)
        let ySection : CGFloat = chartSize.height / CGFloat(self.maxValue)
        let index    : Int     = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSet.dataPoints.count {
            return CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                           y: (chartSize.size.height - CGFloat(dataSet.dataPoints[index].value) * ySection))
        }
        return nil
    }

    public typealias Set       = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    public typealias CTStyle   = BarChartStyle
}



internal struct YAxisDataPointCell<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject var chartData : ChartData
    
    private let label : String
    private let rotationAngle : Angle
    
    internal init(chartData: ChartData, label: String, rotationAngle : Angle) {
        self.chartData     = chartData
        self.label         = label
        self.rotationAngle = rotationAngle
    }
    
    @State private var width: CGFloat = 0
 
    internal var body: some View {

        Text(label)
            .font(.caption)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.width = geo.frame(in: .local).width
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotationAngle, anchor: .center)
            .frame(width: 10, height: width)
            .onAppear {
                chartData.viewData.xAxisLabelHeights.append(width)
            }

    }
}

internal struct YAxisChartDataCell<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject var chartData : ChartData
    
    private let label : String
    
    internal init(chartData: ChartData, label: String) {
        self.chartData     = chartData
        self.label         = label
    }
    
    @State private var height: CGFloat = 0
 
    internal var body: some View {

        Text(label)
            .font(.caption)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.height = geo.frame(in: .local).height
                        }
                }
            )
            .onAppear {
                chartData.viewData.xAxisLabelHeights.append(height)
            }

    }
}
