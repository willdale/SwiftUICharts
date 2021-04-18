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

     let data = StackedBarDataSets(dataSets: [
         StackedBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "1.1", pointLabel: "One One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "1.2", pointLabel: "One Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 30,  xAxisLabel: "1.3", pointLabel: "One Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 40,  xAxisLabel: "1.4", pointLabel: "One Four"   , group: Group.four.data)
         ]),
         StackedBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 50,  xAxisLabel: "2.1", pointLabel: "Two One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "2.2", pointLabel: "Two Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 40,  xAxisLabel: "2.3", pointLabel: "Two Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 60,  xAxisLabel: "2.3", pointLabel: "Two Four"   , group: Group.four.data)
         ]),
         StackedBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 10,  xAxisLabel: "3.1", pointLabel: "Three One"  , group: Group.one.data),
             MultiBarChartDataPoint(value: 50,  xAxisLabel: "3.2", pointLabel: "Three Two"  , group: Group.two.data),
             MultiBarChartDataPoint(value: 30,  xAxisLabel: "3.3", pointLabel: "Three Three", group: Group.three.data),
             MultiBarChartDataPoint(value: 100, xAxisLabel: "3.4", pointLabel: "Three Four" , group: Group.four.data)
         ]),
         StackedBarDataSet(dataPoints: [
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
    
    @Published public final var dataSets     : StackedBarDataSets
    @Published public final var metadata     : ChartMetadata
    @Published public final var xAxisLabels  : [String]?
    @Published public final var yAxisLabels  : [String]?
    @Published public final var barStyle     : BarStyle
    @Published public final var chartStyle   : BarChartStyle
    @Published public final var legends      : [LegendData]
    @Published public final var viewData     : ChartViewData
    @Published public final var infoView     : InfoViewData<MultiBarChartDataPoint> = InfoViewData()
    @Published public final var groups       : [GroupingData]
    
    public final var noDataText   : Text
    public final var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: Initializer
    /// Initialises a Stacked Bar Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - groups: Information for how to group the data points.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - yAxisLabels: Labels for the Y axis instead of the labels generated from data point values.   
    ///   - barStyle: Control for the aesthetic of the bar chart.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : StackedBarDataSets,
                groups      : [GroupingData],
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                yAxisLabels : [String]?         = nil,
                barStyle    : BarStyle          = BarStyle(),
                chartStyle  : BarChartStyle     = BarChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.groups         = groups
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.yAxisLabels    = yAxisLabels
        self.barStyle       = barStyle
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .bar, dataSetType: .multi)
        self.setupLegends()
    }
    // MARK: Labels
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint(let angle):
                HStack(spacing: 0) {
                    ForEach(dataSets.dataSets) { dataSet in
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            XAxisDataPointCell(chartData: self, label: dataSet.setTitle, rotationAngle: angle)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(dataSet.setTitle)"))
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            case .chartData(let angle):
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                            XAxisDataPointCell(chartData: self, label: data, rotationAngle: angle)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .accessibilityLabel(Text("X Axis Label"))
                                .accessibilityValue(Text("\(data)"))
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            }
        }
    }
    // MARK:  Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView()
    }
    
     public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {

         var points : [MultiBarChartDataPoint] = []
         
         // Filter to get the right dataset based on the x axis.
         let superXSection : CGFloat = chartSize.width / CGFloat(dataSets.dataSets.count)
         let superIndex    : Int     = Int((touchLocation.x) / superXSection)
         
         if superIndex >= 0 && superIndex < dataSets.dataSets.count {
             
             let dataSet = dataSets.dataSets[superIndex]
             
             // Get the max value of the dataset relative to max value of all datasets.
             // This is used to set the height of the y axis filtering.
            let setMaxValue = dataSet.maxValue()
             let allMaxValue = self.maxValue
             let fraction : CGFloat = CGFloat(setMaxValue / allMaxValue)

             // Gets the height of each datapoint
             var heightOfElements : [CGFloat] = []
             let sum = dataSet.dataPoints.reduce(0) { $0 + $1.value }
             dataSet.dataPoints.forEach { datapoint in
                 heightOfElements.append((chartSize.height * fraction) * CGFloat(datapoint.value / sum))
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
             
             let yIndex = endPointOfElements.enumerated().first(where: { $0.element > abs(touchLocation.y - chartSize.height) })
             
             if let index = yIndex?.offset {
                 if index >= 0 && index < dataSet.dataPoints.count {
                    var dataPoint = dataSet.dataPoints[index]
                    dataPoint.legendTag = dataSet.setTitle
                    points.append(dataPoint)
                 }
             }
         }
         self.infoView.touchOverlayInfo = points
     }

     public final func getPointLocation(dataSet: StackedBarDataSets, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
         // Filter to get the right dataset based on the x axis.
         let superXSection : CGFloat = chartSize.width / CGFloat(dataSet.dataSets.count)
         let superIndex    : Int     = Int((touchLocation.x) / superXSection)

         if superIndex >= 0 && superIndex < dataSet.dataSets.count {

             let subDataSet = dataSet.dataSets[superIndex]

             // Get the max value of the dataset relative to max value of all datasets.
             // This is used to set the height of the y axis filtering.
             let setMaxValue = subDataSet.maxValue()
             let allMaxValue = self.maxValue
             let fraction : CGFloat = CGFloat(setMaxValue / allMaxValue)

             // Gets the height of each datapoint
             var heightOfElements : [CGFloat] = []
             let sum = subDataSet.dataPoints.reduce(0) { $0 + $1.value }
             subDataSet.dataPoints.forEach { datapoint in
                 heightOfElements.append((chartSize.height * fraction) * CGFloat(datapoint.value / sum))
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
                 $0.element > abs(touchLocation.y - chartSize.height)
             })

             if let index = yIndex?.offset {
                 if index >= 0 && index < subDataSet.dataPoints.count {

                     return CGPoint(x: (CGFloat(superIndex) * superXSection) + (superXSection / 2),
                                    y: (chartSize.height - endPointOfElements[index]))
                 }
             }
         }
         return nil
     }

    public typealias Set        = StackedBarDataSets
    public typealias DataPoint  = MultiBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}
