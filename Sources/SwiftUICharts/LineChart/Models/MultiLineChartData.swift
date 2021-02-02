//
//  MultiLineChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

/// The central model from which the chart is drawn.
public class MultiLineChartData: LineChartDataProtocol {
        
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
    @Published public var isFilled      : Bool = false

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
        self.setupLegends()
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
        self.setupLegends()
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
            
            let minValue : Double
            let range    : Double
            
            switch self.chartStyle.baseline {
            case .minimumValue:
                minValue = self.getMinValue()
                range    = self.getRange()
            case .zero:
                minValue = 0
                range    = self.getMaxValue()
            }
            
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count - 1)
            let ySection : CGFloat = chartSize.size.height / CGFloat(range)
            let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                               y: (CGFloat(dataSet.dataPoints[index].value - minValue) * -ySection) + chartSize.size.height))
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
    
    public func setupLegends() {
        for dataSet in dataSets.dataSets {
            if dataSet.style.colourType == .colour,
               let colour = dataSet.style.colour
            {
                self.legends.append(LegendData(id         : dataSet.id,
                                               legend     : dataSet.legendTitle,
                                               colour     : colour,
                                               strokeStyle: dataSet.style.strokeStyle,
                                               prioity    : 1,
                                               chartType  : .line))
                
            } else if dataSet.style.colourType == .gradientColour,
                      let colours = dataSet.style.colours
            {
                self.legends.append(LegendData(id         : dataSet.id,
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
                self.legends.append(LegendData(id         : dataSet.id,
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
