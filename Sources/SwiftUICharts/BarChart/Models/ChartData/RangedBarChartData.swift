//
//  RangedBarChartData.swift
//  
//
//  Created by Will Dale on 03/03/2021.
//

import SwiftUI

public final class RangedBarChartData: CTRangedBarChartDataProtocol {

    // MARK: Properties
    public let id   : UUID  = UUID()

    @Published public final var dataSets     : RangedBarDataSet
    @Published public final var metadata     : ChartMetadata
    @Published public final var xAxisLabels  : [String]?
    @Published public final var barStyle     : BarStyle
    @Published public final var chartStyle   : BarChartStyle
    @Published public final var legends      : [LegendData]
    @Published public final var viewData     : ChartViewData
    @Published public final var infoView     : InfoViewData<RangedBarDataPoint> = InfoViewData()

    public final var noDataText   : Text
    public final let chartType    : (chartType: ChartType, dataSetType: DataSetType)

    // MARK: Initializer
    /// Initialises a standard Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : RangedBarDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                barStyle    : BarStyle          = BarStyle(),
                chartStyle  : BarChartStyle     = BarChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.barStyle       = barStyle
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText

        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.bar, .single)
//        self.setupLegends()
    }
    
    public final var average  : Double {
        let upperSum = dataSets.dataPoints.reduce(0) { $0 + $1.upperValue }
        let lowerSum = dataSets.dataPoints.reduce(0) { $0 + $1.lowerValue }
        
        let upperAverage = upperSum / Double(dataSets.dataPoints.count)
        let lowerAverage = lowerSum / Double(dataSets.dataPoints.count)
        
        return (upperAverage + lowerAverage) / 2
    }
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:

                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        Text(data.xAxisLabel ?? "")
                            .font(.caption)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .accessibilityLabel( Text("X Axis Label"))
                            .accessibilityValue(Text("\(data.xAxisLabel ?? "")"))
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }

            case .chartData:

                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            if data != labelArray[0] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                            Text(data)
                                .font(.caption)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                                .accessibilityLabel( Text("X Axis Label"))
                                .accessibilityValue(Text("\(data)"))
                            if data != labelArray[labelArray.count-1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(dataSet: dataSets, touchLocation: touchLocation, chartSize: chartSize)
    }
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        var points      : [RangedBarDataPoint] = []
        let xSection    : CGFloat   = chartSize.width / CGFloat(dataSets.dataPoints.count)
        let index       : Int       = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            points.append(dataSets.dataPoints[index])
        }
        self.infoView.touchOverlayInfo = points
    }
    public final func getPointLocation(dataSet: RangedBarDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        let xSection : CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count)
        let ySection : CGFloat = chartSize.height / CGFloat(self.maxValue)
        let index    : Int     = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSet.dataPoints.count {
            
            let upperY = (chartSize.size.height - CGFloat(dataSet.dataPoints[index].upperValue) * ySection)
            let lowerY = (chartSize.size.height - CGFloat(dataSet.dataPoints[index].lowerValue) * ySection)
            
            return CGPoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                           y: upperY - lowerY)
        }
        return nil
    }
    public final func headerTouchOverlaySubView(info: RangedBarDataPoint) -> some View {
        Group {
            switch self.infoView.touchUnit {
            case .none:
                Text("\(info.upperValue, specifier: self.infoView.touchSpecifier)")
                    .font(.title3)
                    .foregroundColor(self.chartStyle.infoBoxValueColour)
                Text("\(info.pointDescription ?? "")")
                    .font(.subheadline)
                    .foregroundColor(self.chartStyle.infoBoxDescriptionColour)
            case .prefix(of: let unit):
                Text("\(unit) \(info.upperValue, specifier: self.infoView.touchSpecifier)")
                    .font(.title3)
                    .foregroundColor(self.chartStyle.infoBoxValueColour)
                Text("\(info.pointDescription ?? "")")
                    .font(.subheadline)
                    .foregroundColor(self.chartStyle.infoBoxDescriptionColour)
            case .suffix(of: let unit):
                Text("\(info.upperValue, specifier: self.infoView.touchSpecifier) \(unit)")
                    .font(.title3)
                    .foregroundColor(self.chartStyle.infoBoxValueColour)
                Text("\(info.pointDescription ?? "")")
                    .font(.subheadline)
                    .foregroundColor(self.chartStyle.infoBoxDescriptionColour)
            }
        }
    }

    public typealias Set            = RangedBarDataSet
    public typealias DataPoint      = RangedBarDataPoint
    public typealias CTStyle        = BarChartStyle
}