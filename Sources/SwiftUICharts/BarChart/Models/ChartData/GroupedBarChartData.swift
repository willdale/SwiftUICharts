//
//  MultiBarChartData.swift
//  
//
//  Created by Will Dale on 26/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a multi line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 
 # Example
 ```
 static func makeData() -> GroupedBarChartData {
     
     let data = MultiBarDataSet(dataSets: [
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"  , colour: .blue),
                     BarChartDataPoint(value: 20, xAxisLabel: "1.2", pointLabel: "One Two"  , colour: .yellow),
                     BarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three", colour: .purple),
                     BarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four" , colour: .green)],
                    legendTitle: "One",
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 50, xAxisLabel: "2.1", pointLabel: "Two One"  , colour: .blue),
                     BarChartDataPoint(value: 10, xAxisLabel: "2.2", pointLabel: "Two Two"  , colour: .yellow),
                     BarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .purple),
                     BarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .green)],
                    legendTitle: "Two",
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 10, xAxisLabel: "3.1", pointLabel: "Three One"  , colour: .blue),
                     BarChartDataPoint(value: 50, xAxisLabel: "3.2", pointLabel: "Three Two"  , colour: .yellow),
                     BarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", colour: .purple),
                     BarChartDataPoint(value: 99, xAxisLabel: "3.4", pointLabel: "Three Four" , colour: .green)],
                    legendTitle: "Three",
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 80, xAxisLabel: "4.1", pointLabel: "Four One"  , colour: .blue),
                     BarChartDataPoint(value: 10, xAxisLabel: "4.2", pointLabel: "Four Two"  , colour: .yellow),
                     BarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .purple),
                     BarChartDataPoint(value: 50, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .green)],
                    legendTitle: "Four",
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints))
     ])
     
     return GroupedBarChartData(dataSets    : data,
                              metadata    : ChartMetadata(title: "Hello", subtitle: "Bob"),
                              xAxisLabels : ["Hello"],
                              chartStyle  : BarChartStyle(),
                              noDataText  : Text("No Data"))
 }
 ```
  
 ---
 
 # Parts
 # BarDataSet
 ```
 BarDataSet(dataPoints: [BarChartDataPoint],
            legendTitle: String,
            style: BarStyle)
 ```
 ## BarChartDataPoint
 ### Options
 Common to all.
 ```
 BarChartDataPoint(value: Double,
                   xAxisLabel: String?,
                   pointLabel: String?,
                   date: Date?,
                   ...)
 ```
 
 Single Colour.
 ```
 BarChartDataPoint(...
                   colour: Color?)
 ```
 
 Gradient Colours.
 ```
 BarChartDataPoint(...
                   colours: [Color]?,
                   startPoint: UnitPoint?,
                   endPoint: UnitPoint?)
 ```
 
 Gradient Colours with stop control.
 ```
 BarChartDataPoint(...
                   stops: [GradientStop]?,
                   startPoint: UnitPoint?,
                   endPoint: UnitPoint?)
 ```
 ## BarStyle
 ### Options
 ```
 BarStyle(barWidth     : CGFloat,
          cornerRadius : CornerRadius,
          colourFrom   : ColourFrom,
          ...)
 
 BarStyle(...
          colour: Color)
 
 BarStyle(...
          colours: [Color],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 
 BarStyle(...
          stops: [GradientStop],
          startPoint: UnitPoint,
          endPoint: UnitPoint)
 ```
 
 ## ChartMetadata
 ```
 ChartMetadata(title: String?, subtitle: String?)
 ```
 
 ## BarChartStyle
 ```
 BarChartStyle(infoBoxPlacement        : InfoBoxPlacement,
               infoBoxValueColour      : Color,
               infoBoxDescriptionColor : Color,
               xAxisGridStyle          : GridStyle,
               xAxisLabelPosition      : XAxisLabelPosistion,
               xAxisLabelColour        : Color,
               xAxisLabelsFrom         : LabelsFrom,
               yAxisGridStyle          : GridStyle,
               yAxisLabelPosition      : YAxisLabelPosistion,
               yAxisLabelColour        : Color,
               yAxisNumberOfLabels     : Int,
               globalAnimation         : Animation)
 ```
 
 ### GridStyle
 ```
 GridStyle(numberOfLines: Int,
           lineColour   : Color,
           lineWidth    : CGFloat,
           dash         : [CGFloat],
           dashPhase    : CGFloat)
 ```
 
 ---
 
 # Also See
 - [BarDataSet](x-source-tag://BarDataSet)
    - [BarChartDataPoint](x-source-tag://BarChartDataPoint)
 - [BarStyle](x-source-tag://BarStyle)
    - [ColourType](x-source-tag://ColourType)
    - [CornerRadius](x-source-tag://CornerRadius)
    - [ColourFrom](x-source-tag://ColourFrom)
    - [GradientStop](x-source-tag://GradientStop)
 - [Chart Metadata](x-source-tag://ChartMetadata)
 - [BarChartStyle](x-source-tag://BarChartStyle)
    - [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
    - [GridStyle](x-source-tag://GridStyle)
    - [XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
    - [LabelsFrom](x-source-tag://LabelsFrom)
    - [YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)

 # Conforms to
 - ObservableObject
 - Identifiable
 - BarChartDataProtocol
 - LineAndBarChartData
 - ChartData
 
 - Tag: GroupedBarChartData
 */
public final class GroupedBarChartData: BarChartDataProtocol {
    
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
    
    var groupSpacing : CGFloat = 0
    
    // MARK: - Initializers
    /// Initialises a multi part Bar Chart with optional calculation
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
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
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.size.width / CGFloat(dataSets.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.size.width / CGFloat(dataSets.dataSets.count)) - compensation
        let index    : Int      = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSection)

        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            let dataSet = dataSets.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(dataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat((groupSpacing * CGFloat(superIndex)))) / xSubSection) - (dataSet.dataPoints.count * index)
            if subIndex >= 0 && subIndex < dataSet.dataPoints.count {
                points.append(dataSet.dataPoints[subIndex])
            }
        }
        return points
    }

    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        var locations : [HashablePoint] = []
        
        // Divide the chart into equal sections.
        let superXSection   : CGFloat   = (chartSize.size.width / CGFloat(dataSets.dataSets.count))
        let superIndex      : Int       = Int((touchLocation.x) / superXSection)
        
        // Work out how much to remove from xSection due to groupSpacing.
        let compensation : CGFloat = ((groupSpacing * CGFloat(dataSets.dataSets.count - 1)) / CGFloat(dataSets.dataSets.count))
        
        // Make those sections take account of spacing between groups.
        let xSection : CGFloat  = (chartSize.size.width / CGFloat(dataSets.dataSets.count)) - compensation
        let ySection : CGFloat  = chartSize.size.height / CGFloat(self.getMaxValue())
        
        let index    : Int      = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(superIndex))) / xSection)

        if index >= 0 && index < dataSets.dataSets.count && superIndex == index {
            
            let dataSet = dataSets.dataSets[index]
            let xSubSection : CGFloat   = (xSection / CGFloat(dataSet.dataPoints.count))
            let subIndex    : Int       = Int((touchLocation.x - CGFloat(groupSpacing * CGFloat(index))) / xSubSection) - (dataSet.dataPoints.count * index)
            
            if subIndex >= 0 && subIndex < dataSet.dataPoints.count {
                let element : CGFloat = (CGFloat(subIndex) * xSubSection) + (xSubSection / 2)
                let section : CGFloat = (superXSection * CGFloat(superIndex))
                let spacing : CGFloat = ((groupSpacing / CGFloat(dataSets.dataSets.count)) * CGFloat(superIndex))
                locations.append(HashablePoint(x: element + section + spacing,
                                               y: (chartSize.size.height - CGFloat(dataSet.dataPoints[subIndex].value) * ySection)))
                
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

public struct GroupedBarLegend {
    
    public let title : String
    public let colour: Color
    
    public init(title: String, colour: Color) {
        self.title = title
        self.colour = colour
    }
}
