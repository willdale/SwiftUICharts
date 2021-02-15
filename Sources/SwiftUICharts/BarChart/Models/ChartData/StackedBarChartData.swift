//
//  StackedBarChartData.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI

public class StackedBarChartData: BarChartDataProtocol {
    
    // MARK: - Properties
    public let id   : UUID  = UUID()
    
    @Published public var dataSets     : GroupedBarDataSets
    @Published public var metadata     : ChartMetadata
    @Published public var xAxisLabels  : [String]?
    @Published public var barStyle     : BarStyle
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView     : InfoViewData<GroupedBarChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : GroupedBarDataSets,
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
        self.chartType      = (chartType: .bar, dataSetType: .multi)
        self.setupLegends()
    }
    // MARK: - Labels
    @ViewBuilder
    public func getXAxisLabels() -> some View {
        switch self.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            HStack(spacing: 0) {
                ForEach(dataSets.dataSets) { dataSet in
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                    Text(dataSet.legendTitle)
                        .font(.caption)
                        .foregroundColor(self.chartStyle.xAxisLabelColour)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        case .chartData:
            if let labelArray = self.xAxisLabels {
                HStack(spacing: 0) {
                    ForEach(labelArray, id: \.self) { data in
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                        Text(data)
                            .font(.caption)
                            .foregroundColor(self.chartStyle.xAxisLabelColour)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
            }
        }
    }
    
    // MARK: - Touch
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [GroupedBarChartDataPoint] {

        var points : [GroupedBarChartDataPoint] = []
        
        // Filter to get the right dataset based on the x axis.
        let superXSection : CGFloat = chartSize.size.width / CGFloat(dataSets.dataSets.count)
        let superIndex    : Int     = Int((touchLocation.x) / superXSection)
        
        if superIndex >= 0 && superIndex < dataSets.dataSets.count {
            
            let dataSet = dataSets.dataSets[superIndex]
            
            // Get the max value of the dataset relative to max value of all datasets.
            // This is used to set the height of the y axis filtering.
            let setMaxValue = dataSet.dataPoints.max { $0.value < $1.value }?.value ?? 0
            let allMaxValue = self.getMaxValue()
            let fraction : CGFloat = CGFloat(setMaxValue / allMaxValue)

            // Gets the height of each datapoint
            var heightOfElements : [CGFloat] = []
            let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
            dataSet.dataPoints.forEach { datapoint in
                heightOfElements.append((chartSize.size.height * fraction) * CGFloat(datapoint.value / sum))
            }
        
            // Gets the highest point of each element.
            var endPointOfElements : [CGFloat] = []
            heightOfElements.enumerated().forEach { element in
                var returnValue : CGFloat = 0
                for index in 0...element.offset {
                    returnValue += heightOfElements[index]
                }
                endPointOfElements.append(returnValue)
            }
            
            let yIndex = endPointOfElements.enumerated().first(where: { $0.element > abs(touchLocation.y - chartSize.size.height) })
            
            if let index = yIndex?.offset {
                if index >= 0 && index < dataSet.dataPoints.count {
                    points.append(dataSet.dataPoints[index])
                }
            }
        }
        return points
    }

    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        let locations : [HashablePoint] = []
        return locations
    }
    
    // MARK: - Legends
    public func setupLegends() {
//        switch dataSets.dataSets[0].style.colourFrom {
//        case .barStyle:
//            if dataSets.dataSets[0].style.colourType == .colour,
//               let colour = dataSets.dataSets[0].style.colour
//            {
//                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
//                                               legend     : dataSets.dataSets[0].legendTitle,
//                                               colour     : colour,
//                                               strokeStyle: nil,
//                                               prioity    : 1,
//                                               chartType  : .bar))
//            } else if dataSets.dataSets[0].style.colourType == .gradientColour,
//                      let colours = dataSets.dataSets[0].style.colours
//            {
//                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
//                                               legend     : dataSets.dataSets[0].legendTitle,
//                                               colours    : colours,
//                                               startPoint : .leading,
//                                               endPoint   : .trailing,
//                                               strokeStyle: nil,
//                                               prioity    : 1,
//                                               chartType  : .bar))
//            } else if dataSets.dataSets[0].style.colourType == .gradientStops,
//                      let stops = dataSets.dataSets[0].style.stops
//            {
//                self.legends.append(LegendData(id         : dataSets.dataSets[0].id,
//                                               legend     : dataSets.dataSets[0].legendTitle,
//                                               stops      : stops,
//                                               startPoint : .leading,
//                                               endPoint   : .trailing,
//                                               strokeStyle: nil,
//                                               prioity    : 1,
//                                               chartType  : .bar))
//            }
//        case .dataPoints:
//
//            for data in dataSets.dataSets[0].dataPoints {
//
//                if data.colourType == .colour,
//                   let colour = data.colour,
//                   let legend = data.pointDescription
//                {
//                    self.legends.append(LegendData(id         : data.id,
//                                                   legend     : legend,
//                                                   colour     : colour,
//                                                   strokeStyle: nil,
//                                                   prioity    : 1,
//                                                   chartType  : .bar))
//                } else if data.colourType == .gradientColour,
//                          let colours = data.colours,
//                          let legend = data.pointDescription
//                {
//                    self.legends.append(LegendData(id         : data.id,
//                                                   legend     : legend,
//                                                   colours    : colours,
//                                                   startPoint : .leading,
//                                                   endPoint   : .trailing,
//                                                   strokeStyle: nil,
//                                                   prioity    : 1,
//                                                   chartType  : .bar))
//                } else if data.colourType == .gradientStops,
//                          let stops = data.stops,
//                          let legend = data.pointDescription
//                {
//                    self.legends.append(LegendData(id         : data.id,
//                                                   legend     : legend,
//                                                   stops      : stops,
//                                                   startPoint : .leading,
//                                                   endPoint   : .trailing,
//                                                   strokeStyle: nil,
//                                                   prioity    : 1,
//                                                   chartType  : .bar))
//                }
//            }
//        }
    }
    public typealias Set        = GroupedBarDataSets
    public typealias DataPoint  = GroupedBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}
