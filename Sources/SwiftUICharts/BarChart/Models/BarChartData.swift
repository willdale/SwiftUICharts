//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public class BarChartData: LineAndBarChartData {

    public let id   : UUID  = UUID()

    @Published public var dataSets     : BarDataSet
    @Published public var metadata     : ChartMetadata?
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData<BarChartDataPoint>
    public var noDataText   : Text  = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : BarDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : BarChartStyle     = BarChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (.bar, .single)
    }
    
    public init(dataSets    : BarDataSet,
                metadata    : ChartMetadata?    = nil,
                xAxisLabels : [String]?         = nil,
                chartStyle  : BarChartStyle     = BarChartStyle(),
                customCalc  : @escaping ([BarChartDataPoint]) -> [BarChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .bar, dataSetType: .single)
    }
    
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [BarChartDataPoint] {
        var points      : [BarChartDataPoint] = []
        let xSection    : CGFloat   = chartSize.size.width / CGFloat(dataSets.dataPoints.count)
        let index       : Int       = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            points.append(dataSets.dataPoints[index])
        }
        return points
    }

    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        var locations : [HashablePoint] = []
        
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count)
        let ySection : CGFloat = chartSize.size.height / CGFloat(DataFunctions.dataSetMaxValue(from: dataSets))
        let index    : Int     = Int((touchLocation.x) / xSection)
        
        if index >= 0 && index < dataSets.dataPoints.count {
            locations.append(HashablePoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                           y: (chartSize.size.height - CGFloat(dataSets.dataPoints[index].value) * ySection)))
        }
        return locations
    }
        
    public func getXAxidLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(dataSets.dataPoints) { data in
                Spacer()
                    .frame(minWidth: 0, maxWidth: 500)
                Text(data.xAxisLabel ?? "")
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
            }
        }
    }
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = DataFunctions.dataSetMaxValue(from: dataSets)
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
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
    
    public func setupLegends() {
        switch self.dataSets.style.colourFrom {
        case .barStyle:
            if dataSets.style.colourType == .colour,
               let colour = dataSets.style.colour
            {
                self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                               colour     : colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.style.colourType == .gradientColour,
                      let colours = dataSets.style.colours
            {
                self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.style.colourType == .gradientStops,
                      let stops = dataSets.style.stops
            {
                self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                               stops      : stops,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            }
        case .dataPoints:
            
            for data in dataSets.dataPoints {
                
                if data.colourType == .colour,
                   let colour = data.colour,
                   let legend = data.pointDescription
                {
                    self.legends.append(LegendData(legend     : legend,
                                                   colour     : colour,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.colourType == .gradientColour,
                          let colours = data.colours,
                          let legend = data.pointDescription
                {
                    self.legends.append(LegendData(legend     : legend,
                                                   colours    : colours,
                                                   startPoint : .leading,
                                                   endPoint   : .trailing,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.colourType == .gradientStops,
                          let stops = data.stops,
                          let legend = data.pointDescription
                {
                    self.legends.append(LegendData(legend     : legend,
                                                   stops      : stops,
                                                   startPoint : .leading,
                                                   endPoint   : .trailing,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                }
            }
        }
    }
    
    public typealias Set = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    
}

