//
//  StackedBarChartData.swift
//  
//
//  Created by Will Dale on 12/02/2021.
//

import SwiftUI

/**
 Data model for drawing and styling a Stacked Bar Chart.
 
 The grouping data informs the model as to how the datapoints are linked.
 
 # Example
 ```
 static func makeData() -> StackedBarChartData {
     
     enum Group {
         case one
         case two
         case three
         case four
         
         var data : GroupingData {
             switch self {
             case .one:
                 return GroupingData(title: "One"  , colour: .blue)
             case .two:
                 return GroupingData(title: "Two"  , colour: .red)
             case .three:
                 return GroupingData(title: "Three", colour: .yellow)
             case .four:
                 return GroupingData(title: "Four" , colour: .green)
             }
         }
     }
     
     let groups : [GroupingData] = [Group.one.data, Group.two.data, Group.three.data, Group.four.data]

     let data = MultiBarDataSets(dataSets: [
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "1.1", pointLabel: "One One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "1.2", pointLabel: "One Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 30,  xAxisLabel: "1.3", pointLabel: "One Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 40,  xAxisLabel: "1.4", pointLabel: "One Four"   , group: Group.four.data)
         ]),
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 50,  xAxisLabel: "2.1", pointLabel: "Two One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "2.2", pointLabel: "Two Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 40,  xAxisLabel: "2.3", pointLabel: "Two Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 60,  xAxisLabel: "2.3", pointLabel: "Two Four"   , group: Group.four.data)
         ]),
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "3.1", pointLabel: "Three One"  , group: Group.one.data),
             MultiBarChartDataPoint(value: 50,  xAxisLabel: "3.2", pointLabel: "Three Two"  , group: Group.two.data),
             MultiBarChartDataPoint(value: 30,  xAxisLabel: "3.3", pointLabel: "Three Three", group: Group.three.data),
             MultiBarChartDataPoint(value: 100, xAxisLabel: "3.4", pointLabel: "Three Four" , group: Group.four.data)
         ]),
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 80,  xAxisLabel: "4.1", pointLabel: "Four One"   , group: Group.one.data),
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "4.2", pointLabel: "Four Two"   , group: Group.two.data),
             MultiBarChartDataPoint(value: 20,  xAxisLabel: "4.3", pointLabel: "Four Three" , group: Group.three.data),
             MultiBarChartDataPoint(value: 50,  xAxisLabel: "4.3", pointLabel: "Four Four"  , group: Group.four.data)
         ])
     ])

     
     return StackedBarChartData(dataSets: data,
                                groups: groups,
                                metadata: ChartMetadata(title: "Hello", subtitle: "World"),
                                chartStyle: BarChartStyle(xAxisLabelsFrom: .dataPoint))
 ```
 */
public final class StackedBarChartData: CTMultiBarChartDataProtocol {
    
    // MARK: Properties
    public let id   : UUID  = UUID()
    
    @Published public var dataSets     : MultiBarDataSets
    @Published public var metadata     : ChartMetadata
    @Published public var xAxisLabels  : [String]?
    @Published public var barStyle     : BarStyle
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView     : InfoViewData<MultiBarChartDataPoint> = InfoViewData()
    @Published public var groups       : [GroupingData]
    
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: Initializer
    /// Initialises a Grouped Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : MultiBarDataSets,
                groups      : [GroupingData],
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                barStyle    : BarStyle          = BarStyle(),
                chartStyle  : BarChartStyle     = BarChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.groups         = groups
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
    // MARK: Labels
    @ViewBuilder
    public func getXAxisLabels() -> some View {
        switch self.chartStyle.xAxisLabelsFrom {
        case .dataPoint:
            HStack(spacing: 0) {
                ForEach(groups) { group in
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                    Text(group.title)
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
        let maxValue: Double    = self.maxValue
        for index in 0...self.chartStyle.yAxisNumberOfLabels {
            labels.append(maxValue / Double(self.chartStyle.yAxisNumberOfLabels) * Double(index))
        }
        return labels
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize.frame(in: .local)
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }

    @ViewBuilder
    public func getTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View {
        
        if let position = self.getPointLocation(dataSet: dataSets,
                                                touchLocation: touchLocation,
                                                chartSize: chartSize) {
            ZStack {
                
                switch self.chartStyle.markerType  {
                case .none:
                    EmptyView()
                case .vertical:
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
        } else { EmptyView() }
    }

    public typealias Set        = MultiBarDataSets
    public typealias DataPoint  = MultiBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}

// MARK: - Touch
extension StackedBarChartData: TouchProtocol {
   
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) {

        var points : [MultiBarChartDataPoint] = []
        
        // Filter to get the right dataset based on the x axis.
        let superXSection : CGFloat = chartSize.size.width / CGFloat(dataSets.dataSets.count)
        let superIndex    : Int     = Int((touchLocation.x) / superXSection)
        
        if superIndex >= 0 && superIndex < dataSets.dataSets.count {
            
            let dataSet = dataSets.dataSets[superIndex]
            
            // Get the max value of the dataset relative to max value of all datasets.
            // This is used to set the height of the y axis filtering.
            let setMaxValue = dataSet.dataPoints.max { $0.value < $1.value }?.value ?? 0
            let allMaxValue = self.maxValue
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
        self.infoView.touchOverlayInfo = points
    }

    public func getPointLocation(dataSet: MultiBarDataSets, touchLocation: CGPoint, chartSize: GeometryProxy) -> CGPoint? {
        // Filter to get the right dataset based on the x axis.
        let superXSection : CGFloat = chartSize.size.width / CGFloat(dataSet.dataSets.count)
        let superIndex    : Int     = Int((touchLocation.x) / superXSection)

        if superIndex >= 0 && superIndex < dataSet.dataSets.count {

            let subDataSet = dataSet.dataSets[superIndex]

            // Get the max value of the dataset relative to max value of all datasets.
            // This is used to set the height of the y axis filtering.
            let setMaxValue = subDataSet.dataPoints.max { $0.value < $1.value }?.value ?? 0
            let allMaxValue = self.maxValue
            let fraction : CGFloat = CGFloat(setMaxValue / allMaxValue)

            // Gets the height of each datapoint
            var heightOfElements : [CGFloat] = []
            let sum = subDataSet.dataPoints.reduce(0) { $0 + $1.value }
            subDataSet.dataPoints.forEach { datapoint in
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

            let yIndex = endPointOfElements.enumerated().first(where: {
                $0.element > abs(touchLocation.y - chartSize.size.height)
            })

            if let index = yIndex?.offset {
                if index >= 0 && index < subDataSet.dataPoints.count {

                    return CGPoint(x: (CGFloat(superIndex) * superXSection) + (superXSection / 2),
                                   y: (chartSize.size.height - endPointOfElements[index]))
                }
            }
        }
        return nil
    }
}

extension StackedBarChartData: LegendProtocol {
    // MARK: - Legends
    internal func setupLegends() {
        for group in self.groups {
                
                if group.colourType == .colour,
                   let colour = group.colour
                {
                    self.legends.append(LegendData(id         : group.id,
                                                   legend     : group.title,
                                                   colour     : colour,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if group.colourType == .gradientColour,
                          let colours = group.colours
                {
                    self.legends.append(LegendData(id         : group.id,
                                                   legend     : group.title,
                                                   colours    : colours,
                                                   startPoint : .leading,
                                                   endPoint   : .trailing,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                } else if group.colourType == .gradientStops,
                          let stops  = group.stops
                {
                    self.legends.append(LegendData(id         : group.id,
                                                   legend     : group.title,
                                                   stops      : stops,
                                                   startPoint : .leading,
                                                   endPoint   : .trailing,
                                                   strokeStyle: nil,
                                                   prioity    : 1,
                                                   chartType  : .bar))
                }
            }
    }
    
    internal func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}
