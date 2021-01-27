//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class LineChartData: LineAndBarChartData, LineChartProtocol {
    
    public let id   : UUID  = UUID()
    
    /// Data model containing the datapoints: Value, Label, Description and Date. Individual colouring for bar chart.
    @Published public var dataSets      : LineDataSet
    
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    @Published public var metadata      : ChartMetadata?
    
    /// Array of strings for the labels on the X Axis instead of the the dataPoints labels.
    @Published public var xAxisLabels   : [String]?
    
    /// Data model conatining the style data for the chart.
    @Published public var chartStyle    : LineChartStyle
                
    /// Array of data to populate the chart legend.
    @Published public var legends       : [LegendData]
    
    /// Data model to hold data about the Views layout.
    @Published public var viewData      : ChartViewData<LineChartDataPoint>
    
    public var noDataText   : Text      = Text("No Data")
    
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
            
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle = LineChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
    }
    
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle = LineChartStyle(),
                customCalc  : @escaping ([LineChartDataPoint]) -> [LineChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
    }
    
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [LineChartDataPoint] {
        var points      : [LineChartDataPoint] = []
        let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            points.append(dataSets.dataPoints[index])
        }
        return points
    }

    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        var locations : [HashablePoint] = []
        
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count - 1)
        let ySection : CGFloat = chartSize.size.height / CGFloat(DataFunctions.dataSetRange(from: dataSets))
        let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                           y: (CGFloat(dataSets.dataPoints[index].value - DataFunctions.dataSetMinValue(from: dataSets)) * -ySection) + chartSize.size.height))
        }
        return locations
    }
    public func getXAxidLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(dataSets.dataPoints) { data in
                Text(data.xAxisLabel ?? "")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                if data != self.dataSets.dataPoints[self.dataSets.dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = DataFunctions.dataSetRange(from: dataSets)
        let minValue    : Double    = DataFunctions.dataSetMinValue(from: dataSets)
        
        let range       : Double    = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
    
    public func getRange() -> Double {
        DataFunctions.dataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.dataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.dataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.dataSetAverage(from: dataSets)
    }
    
    public typealias Set       = LineDataSet
    public typealias DataPoint = LineChartDataPoint
}
