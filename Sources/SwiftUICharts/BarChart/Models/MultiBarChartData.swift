//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

public class MultiBarChartData: LineAndBarChartData {

    public let id   : UUID  = UUID()

    @Published public var dataSets     : MultiBarDataSet
    @Published public var metadata     : ChartMetadata?
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView      : InfoViewData<BarChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text  = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : MultiBarDataSet,
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
        self.chartType      = (chartType: .bar, dataSetType: .multi)
    }
    
    public init(dataSets    : MultiBarDataSet,
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
        self.chartType      = (chartType: .bar, dataSetType: .multi)
    }

    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [BarChartDataPoint] {
        var points : [BarChartDataPoint] = []
        for dataSet in dataSets.dataSets {
            let xSection    : CGFloat   = chartSize.size.width / CGFloat(dataSet.dataPoints.count)
            let index       : Int       = Int((touchLocation.x) / xSection)
            if index >= 0 && index < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[index])
            }
        }
        return points
    }
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        var locations : [HashablePoint] = []
        for dataSet in dataSets.dataSets {
            let xSection : CGFloat = chartSize.size.width / CGFloat(dataSet.dataPoints.count)
            let ySection : CGFloat = chartSize.size.height / CGFloat(DataFunctions.multiDataSetMaxValue(from: dataSets))
            
            let index = Int((touchLocation.x) / xSection)
            
            if index >= 0 && index < dataSet.dataPoints.count {
                locations.append(HashablePoint(x: (CGFloat(index) * xSection) + (xSection / 2),
                                               y: (chartSize.size.height - CGFloat(dataSet.dataPoints[index].value) * ySection)))
            }
        }
        return locations
    }
    public func getXAxidLabels() -> some View {
        HStack(spacing: 100) {
            ForEach(dataSets.dataSets) { dataSet in
                HStack(spacing: 0) {
                    ForEach(dataSet.dataPoints) { data in
                        Text(data.xAxisLabel ?? "")
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        if data != dataSet.dataPoints[dataSet.dataPoints.count - 1] {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, -4)
    }
    public func getYLabels() -> [Double] {
        var labels : [Double]  = [Double]()
        let maxValue    : Double    = DataFunctions.multiDataSetMaxValue(from: dataSets)
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
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
        switch dataSets.dataSets[0].style.colourFrom {
        case .barStyle:
            if dataSets.dataSets[0].style.colourType == .colour,
               let colour = dataSets.dataSets[0].style.colour
            {
                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
                                               legend     : dataSets.dataSets[0].legendTitle,
                                               colour     : colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.dataSets[0].style.colourType == .gradientColour,
                      let colours = dataSets.dataSets[0].style.colours
            {
                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
                                               legend     : dataSets.dataSets[0].legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.dataSets[0].style.colourType == .gradientStops,
                      let stops = dataSets.dataSets[0].style.stops
            {
                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
                                               legend     : dataSets.dataSets[0].legendTitle,
                                               stops      : stops,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            }
        case .dataPoints:
            
            for data in dataSets.dataSets[0].dataPoints {
                
                if data.colourType == .colour,
                   let colour = data.colour,
                   let legend = data.pointDescription
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
                                                   colour     : colour,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if data.colourType == .gradientColour,
                          let colours = data.colours,
                          let legend = data.pointDescription
                {
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
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
                    self.legends.append(LegendData(id         : data.id,
                                                   legend     : legend,
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
    
    public typealias Set = MultiBarDataSet
    public typealias DataPoint = BarChartDataPoint
}

