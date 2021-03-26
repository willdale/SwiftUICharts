//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a single line, line chart.
 
 This model contains the data and styling information for a single line, line chart.
 */
public final class LineChartData: CTLineChartDataProtocol {
    
    // MARK: Properties
    public final let id   : UUID  = UUID()
    
    @Published public final var dataSets      : LineDataSet
    @Published public final var metadata      : ChartMetadata
    @Published public final var xAxisLabels   : [String]?
    @Published public final var yAxisLabels   : [String]?
    @Published public final var chartStyle    : LineChartStyle
    @Published public final var legends       : [LegendData]
    @Published public final var viewData      : ChartViewData
    @Published public final var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
        
    public final var noDataText   : Text
    public final var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    internal final var isFilled      : Bool = false
    
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
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                yAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.yAxisLabels    = yAxisLabels
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
        self.setupLegends()
    }
    // , calc        : @escaping (LineDataSet) -> LineDataSet
    
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
                        YAxisDataPointCell(chartData: self, label: data.wrappedXAxisLabel, rotationAngle: angle)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .accessibilityLabel(Text("X Axis Label"))
                            .accessibilityValue(Text("\(data.wrappedXAxisLabel)"))
                        if data != self.dataSets.dataPoints[self.dataSets.dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
                .padding(.horizontal, -4)
                
            case .chartData:
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            YAxisChartDataCell(chartData: self, label: data)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(data)"))
                            if data != labelArray[labelArray.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                }
            }
        }
    }

    // MARK: Points
    public final func getPointMarker() -> some View {
        PointsSubView(dataSets  : dataSets,
                      minValue  : self.minValue,
                      range     : self.range,
                      animation : self.chartStyle.globalAnimation,
                      isFilled  : self.isFilled)
    }

    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(dataSet: dataSets,
                           dataPoints: dataSets.dataPoints,
                           lineType: dataSets.style.lineType,
                           touchLocation: touchLocation,
                           chartSize: chartSize)
    }

    public typealias Set       = LineDataSet
    public typealias DataPoint = LineChartDataPoint
}

// MARK: - Touch
extension LineChartData {
    
    public final func getPointLocation(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
        let minValue : Double = self.minValue
        let range    : Double = self.range
        
        let xSection : CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
        let ySection : CGFloat = chartSize.height / CGFloat(range)
        
        let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
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
        
        var points      : [LineChartDataPoint] = []
        let xSection    : CGFloat = chartSize.width / CGFloat(dataSets.dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            if !dataSets.style.ignoreZero {
                var dataPoint = dataSets.dataPoints[index]
                dataPoint.legendTag = dataSets.legendTitle
                points.append(dataPoint)
            } else {
                if dataSets.dataPoints[index].value != 0 {
                    var dataPoint = dataSets.dataPoints[index]
                    dataPoint.legendTag = dataSets.legendTitle
                    points.append(dataPoint)
                } else {
                    var dataPoint = dataSets.dataPoints[index]
                    dataPoint.legendTag = dataSets.legendTitle
                    dataPoint.value = -Double.greatestFiniteMagnitude
                    points.append(dataPoint)
                }
            }
        }
        self.infoView.touchOverlayInfo = points
    }
}
