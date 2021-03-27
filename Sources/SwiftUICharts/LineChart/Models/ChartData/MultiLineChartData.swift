//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a multi line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 */
public final class MultiLineChartData: CTLineChartDataProtocol {

    // MARK: Properties
    public let id   : UUID = UUID()
    
    @Published public final var dataSets      : MultiLineDataSet
    @Published public final var metadata      : ChartMetadata
    @Published public final var xAxisLabels   : [String]?
    @Published public final var yAxisLabels   : [String]?
    @Published public final var chartStyle    : LineChartStyle
    @Published public final var legends       : [LegendData]
    @Published public final var viewData      : ChartViewData
    @Published public final var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public final var noDataText   : Text
    public final var chartType    : (chartType: ChartType, dataSetType: DataSetType)
        
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
    public init(dataSets    : MultiLineDataSet,
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
        self.chartType      = (.line, .multi)
        self.setupLegends()
    }

    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets[0].dataPoints) { data in
                        XAxisDataPointCell(chartData: self, label: data.wrappedXAxisLabel, rotationAngle: angle)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .accessibilityLabel(Text("X Axis Label"))
                            .accessibilityValue(Text("\(data.wrappedXAxisLabel)"))
                        if data != self.dataSets.dataSets[0].dataPoints[self.dataSets.dataSets[0].dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
                .padding(.horizontal, -4)
                
            case .chartData:
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray.indices, id: \.self) { [unowned self] i in
                            XAxisChartDataCell(chartData: self, label: labelArray[i])
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(labelArray[i])"))
                            if i != labelArray.count - 1 {
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
        ForEach(self.dataSets.dataSets, id: \.id) { dataSet in
            PointsSubView(dataSets  : dataSet,
                          minValue  : self.minValue,
                          range     : self.range,
                          animation : self.chartStyle.globalAnimation,
                          isFilled  : false)
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
        }
    }
    
    // MARK: Accessibility
    public func getAccessibility() -> some View {
      ForEach(self.dataSets.dataSets, id: \.self) { dataSet in
            ForEach(dataSet.dataPoints.indices, id: \.self) { point in
                AccessibilityRectangle(dataPointCount : dataSet.dataPoints.count,
                                       dataPointNo    : point)
                    .foregroundColor(Color(.gray).opacity(0.000000001))
                    .accessibilityLabel(Text("\(self.metadata.title)"))
                    .accessibilityValue(dataSet.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
            }
        }
    }
    
    public typealias Set        = MultiLineDataSet
    public typealias DataPoint  = LineChartDataPoint
    public typealias CTStyle    = LineChartStyle
}


// MARK: - Touch
extension MultiLineChartData {
    public func getPointLocation(dataSet: LineDataSet, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
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
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        var points : [LineChartDataPoint] = []
        for dataSet in dataSets.dataSets {
            let xSection    : CGFloat = chartSize.width / CGFloat(dataSet.dataPoints.count - 1)
            let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                if !dataSet.style.ignoreZero {
                    var dataPoint = dataSet.dataPoints[index]
                    dataPoint.legendTag = dataSet.legendTitle
                    points.append(dataPoint)
                } else {
                    if dataSet.dataPoints[index].value != 0 {
                        var dataPoint = dataSet.dataPoints[index]
                        dataPoint.legendTag = dataSet.legendTitle
                        points.append(dataPoint)
                    } else {
                        var dataPoint = dataSet.dataPoints[index]
                        dataPoint.legendTag = dataSet.legendTitle
                        dataPoint.value = -Double.greatestFiniteMagnitude
                        points.append(dataPoint)
                    }
                }
            }
        }
        self.infoView.touchOverlayInfo = points
    }
}
