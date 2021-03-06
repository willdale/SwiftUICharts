//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

/**
 Data model for drawing and styling a Grouped Bar Chart.
  
 The grouping data informs the model as to how the datapoints are linked.
 
 # Example
 ```
 static func makeData() -> GroupedBarChartData {

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
             MultiBarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 50, xAxisLabel: "1.2", pointLabel: "One Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four"   , group: Group.four.data)
         ]),
         
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 20, xAxisLabel: "2.1", pointLabel: "Two One"    , group: Group.one.data),
             MultiBarChartDataPoint(value: 60, xAxisLabel: "2.2", pointLabel: "Two Two"    , group: Group.two.data),
             MultiBarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three"  , group: Group.three.data),
             MultiBarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Four"   , group: Group.four.data)
         ]),
         
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 30, xAxisLabel: "3.1", pointLabel: "Three One"  , group: Group.one.data),
             MultiBarChartDataPoint(value: 70, xAxisLabel: "3.2", pointLabel: "Three Two"  , group: Group.two.data),
             MultiBarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", group: Group.three.data),
             MultiBarChartDataPoint(value: 90, xAxisLabel: "3.4", pointLabel: "Three Four" , group: Group.four.data)
         ]),
         
         MultiBarDataSet(dataPoints: [
             MultiBarChartDataPoint(value: 40, xAxisLabel: "4.1", pointLabel: "Four One"   , group: Group.one.data),
             MultiBarChartDataPoint(value: 80, xAxisLabel: "4.2", pointLabel: "Four Two"   , group: Group.two.data),
             MultiBarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three" , group: Group.three.data),
             MultiBarChartDataPoint(value: 50, xAxisLabel: "4.3", pointLabel: "Four Four"  , group: Group.four.data)
         ])
     ])
     
     return GroupedBarChartData(dataSets    : data,
                                groups      : groups,
                                metadata    : ChartMetadata(title: "Hello", subtitle: "Bob"),
                                chartStyle  : BarChartStyle(infoBoxPlacement: .floating,
                                                            xAxisLabelsFrom : .dataPoint))
 }
 ```
 */
public final class GroupedBarChartData: CTMultiBarChartDataProtocol {
    
    // MARK: Properties
    public let id   : UUID  = UUID()

    @Published public final var dataSets     : MultiBarDataSets
    @Published public final var metadata     : ChartMetadata
    @Published public final var xAxisLabels  : [String]?
    @Published public final var barStyle     : BarStyle
    @Published public final var chartStyle   : BarChartStyle
    @Published public final var legends      : [LegendData]
    @Published public final var viewData     : ChartViewData
    @Published public final var infoView     : InfoViewData<MultiBarChartDataPoint> = InfoViewData()
    @Published public final var groups       : [GroupingData]
    
    public final var noDataText   : Text
    public final var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    final var groupSpacing : CGFloat = 0
        
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
    public final func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:
                HStack(spacing: self.groupSpacing) {
                    ForEach(dataSets.dataSets) { dataSet in
                        HStack(spacing: 0) {
                            ForEach(dataSet.dataPoints) { data in
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                                Text(data.xAxisLabel ?? "")
                                    .font(.caption)
                                    .foregroundColor(self.chartStyle.xAxisLabelColour)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .accessibilityLabel( Text("XAxisLabel"))
                                    .accessibilityValue(Text("\(data.xAxisLabel ?? "")"))
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                }
                .padding(.horizontal, -4)
                
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
                                .accessibilityLabel( Text("XAxisLabel"))
                                .accessibilityValue(Text("\(data)"))
                            Spacer()
                                .frame(minWidth: 0, maxWidth: 500)
                        }
                    }
                }
            }
        }
    }
    // MARK: Touch
    public final func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView()
    }
    public final func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) {
        
        var points : [MultiBarChartDataPoint] = []
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.width / CGFloat(dataSets.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.width / CGFloat(dataSets.dataSets.count)) - compensation
        let index    : Int      = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSection)

        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            let dataSet = dataSets.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(dataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSubSection) - (dataSet.dataPoints.count * index)
            if subIndex >= 0 && subIndex < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[subIndex])
            }
        }
        self.infoView.touchOverlayInfo = points
    }
    public final func getPointLocation(dataSet: MultiBarDataSets, touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.width / CGFloat(dataSet.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)

        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSet.dataSets.count - 1)) / CGFloat(dataSet.dataSets.count))

        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.width / CGFloat(dataSet.dataSets.count)) - compensation
        let ySection : CGFloat  = chartSize.height / CGFloat(self.maxValue)

        let index    : Int      = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)

        if index >= 0 && index < dataSet.dataSets.count && superIndex == index {

            let subDataSet = dataSet.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(subDataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(index))) / xSubSection) - (subDataSet.dataPoints.count * index)

            if subIndex >= 0 && subIndex < subDataSet.dataPoints.count {
                let element : CGFloat = (CGFloat(subIndex) * xSubSection) + (xSubSection / 2)
                let section : CGFloat = (superXSection * CGFloat(superIndex))
                let spacing : CGFloat = ((groupSpacing / CGFloat(dataSets.dataSets.count)) * CGFloat(superIndex))
                return CGPoint(x: element + section + spacing,
                               y: (chartSize.height - CGFloat(subDataSet.dataPoints[subIndex].value) * ySection))
            }
        }
        return nil
    }
    
    public typealias Set        = MultiBarDataSets
    public typealias DataPoint  = MultiBarChartDataPoint
    public typealias CTStyle    = BarChartStyle
}
