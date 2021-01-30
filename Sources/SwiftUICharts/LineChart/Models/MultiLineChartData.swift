//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class MultiLineChartData: LineAndBarChartData, LineChartProtocol {
        
    public let id   : UUID  = UUID()
    
    /// Data model containing the datapoints: Value, Label, Description and Date. Individual colouring for bar chart.
    @Published public var dataSets      : MultiLineDataSet
    
    /// Data model containing: the charts Title, the charts Subtitle and the Line Legend.
    @Published public var metadata      : ChartMetadata?
    
    /// Array of strings for the labels on the X Axis instead of the the dataPoints labels.
    @Published public var xAxisLabels   : [String]?
    
    /// Data model conatining the style data for the chart.
    @Published public var chartStyle    : LineChartStyle
                
    /// Array of data to populate the chart legend.
    @Published public var legends       : [LegendData]
    
    /// Data model to hold data about the Views layout.
    @Published public var viewData      : ChartViewData
    
    @Published public var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text = Text("No Data")
    
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
            
    public init(dataSets    : MultiLineDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.line, .multi)
    }
    
    public init(dataSets    : MultiLineDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                customCalc  : @escaping ([LineChartDataPoint]) -> [LineChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .multi)
    }
    
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }

    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [LineChartDataPoint] {
        var points : [LineChartDataPoint] = []
        for dataSet in dataSets.dataSets {
            let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[index])
            }
        }
        return points
    }
    
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {

        var locations : [HashablePoint] = []
        for dataSet in dataSets.dataSets {
            
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection : CGFloat = chartSize.size.height / CGFloat(DataFunctions.multiDataSetRange(from: dataSets))
            let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                               y: (CGFloat(dataSet.dataPoints[index].value - DataFunctions.multiDataSetMinValue(from: dataSets)) * -ySection) + chartSize.size.height))
            }
        }
        return locations
    }
    public func getXAxidLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(dataSets.dataSets[0].dataPoints) { data in
                if let label = data.xAxisLabel {
                    Text(label)
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                if data != self.dataSets.dataSets[0].dataPoints[self.dataSets.dataSets[0].dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double    = DataFunctions.multiDataSetRange(from: dataSets)
        let minValue    : Double    = DataFunctions.multiDataSetMinValue(from: dataSets)
        
        let range       : Double    = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)
        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
    
    public func getRange() -> Double {
        DataFunctions.multiDataSetRange(from: dataSets)
    }
    public func getMinValue() -> Double {
        DataFunctions.multiDataSetMinValue(from: dataSets)
    }
    public func getMaxValue() -> Double {
        DataFunctions.multiDataSetMaxValue(from: dataSets)
    }
    public func getAverage() -> Double {
        DataFunctions.multiDataSetAverage(from: dataSets)
    }
    
    public func setupLegends() {
        for dataSet in dataSets.dataSets {
            if dataSet.style.colourType == .colour,
               let colour = dataSet.style.colour
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : colour,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.colourType == .gradientColour,
                      let colours = dataSet.style.colours
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSet.legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.colourType == .gradientStops,
                      let stops = dataSet.style.stops
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSet.legendTitle,
                                               stops      : stops,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
            }
        }
    }
    
    public typealias Set = MultiLineDataSet
    public typealias DataPoint = LineChartDataPoint
}
