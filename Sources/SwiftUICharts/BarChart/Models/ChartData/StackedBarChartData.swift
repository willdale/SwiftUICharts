//
//  StackedBarChartData.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI

public final class StackedBarChartData: BarChartDataProtocol {
    
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
    
    public var groupLegends : [GroupedBarLegend]
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : GroupedBarDataSets,
                groupLegends: [GroupedBarLegend],
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
        self.groupLegends   = groupLegends
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
    
    public func getYLabels() -> [Double] {
        var labels  : [Double]  = [Double]()
        let maxValue: Double    = self.getMaxValue()
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
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
        var locations : [HashablePoint] = []
        
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
                    
                    locations.append(HashablePoint(x: (CGFloat(superIndex) * superXSection) + (superXSection / 2),
                                                   y: (chartSize.size.height - endPointOfElements[index])))
                }
            }
        }
        
        return locations
    }
    
    public func touchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View {
        let positions = self.getPointLocation(touchLocation: touchLocation,
                                              chartSize: chartSize)
        return ZStack {
            ForEach(positions, id: \.self) { position in
                
                switch self.chartStyle.markerType  {
                case .vertical:
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .rectangle:
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .full:
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .bottomLeading:
                    MarkerBottomLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .bottomTrailing:
                    MarkerBottomTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .topLeading:
                    MarkerTopLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                case .topTrailing:
                    MarkerTopTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                }
            }
        }
    }
    
    // MARK: - Legends
    public func setupLegends() {
        for legend in self.groupLegends {
            self.legends.append(LegendData(id: UUID(),
                                           legend: legend.title,
                                           colour: legend.colour,
                                           strokeStyle: nil,
                                           prioity: 1,
                                           chartType: .bar))
        }
    }
    public typealias Set        = GroupedBarDataSets
    public typealias DataPoint  = GroupedBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}
