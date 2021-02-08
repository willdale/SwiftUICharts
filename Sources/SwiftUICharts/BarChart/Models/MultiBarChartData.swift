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
 static func makeData() -> MultiBarChartData {
     
     let data = MultiBarDataSet(dataSets: [
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 10, xAxisLabel: "1.1", pointLabel: "One One"  , colour: .blue),
                     BarChartDataPoint(value: 20, xAxisLabel: "1.2", pointLabel: "One Two"  , colour: .yellow),
                     BarChartDataPoint(value: 30, xAxisLabel: "1.3", pointLabel: "One Three", colour: .purple),
                     BarChartDataPoint(value: 40, xAxisLabel: "1.4", pointLabel: "One Four" , colour: .green)],
                    legendTitle: "One",
                    pointStyle: PointStyle(),
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 50, xAxisLabel: "2.1", pointLabel: "Two One"  , colour: .blue),
                     BarChartDataPoint(value: 10, xAxisLabel: "2.2", pointLabel: "Two Two"  , colour: .yellow),
                     BarChartDataPoint(value: 40, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .purple),
                     BarChartDataPoint(value: 60, xAxisLabel: "2.3", pointLabel: "Two Three", colour: .green)],
                    legendTitle: "Two",
                    pointStyle: PointStyle(),
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 10, xAxisLabel: "3.1", pointLabel: "Three One"  , colour: .blue),
                     BarChartDataPoint(value: 50, xAxisLabel: "3.2", pointLabel: "Three Two"  , colour: .yellow),
                     BarChartDataPoint(value: 30, xAxisLabel: "3.3", pointLabel: "Three Three", colour: .purple),
                     BarChartDataPoint(value: 99, xAxisLabel: "3.4", pointLabel: "Three Four" , colour: .green)],
                    legendTitle: "Three",
                    pointStyle: PointStyle(),
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints)),
         BarDataSet(dataPoints: [
                     BarChartDataPoint(value: 80, xAxisLabel: "4.1", pointLabel: "Four One"  , colour: .blue),
                     BarChartDataPoint(value: 10, xAxisLabel: "4.2", pointLabel: "Four Two"  , colour: .yellow),
                     BarChartDataPoint(value: 20, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .purple),
                     BarChartDataPoint(value: 50, xAxisLabel: "4.3", pointLabel: "Four Three", colour: .green)],
                    legendTitle: "Four",
                    pointStyle: PointStyle(),
                    style: BarStyle(barWidth: 1.0, colourFrom: .dataPoints))
     ])
     
     return MultiBarChartData(dataSets: data,
                              metadata: ChartMetadata(title: "Hello", subtitle: "Bob"),
                              xAxisLabels: ["Hello"],
                              chartStyle: BarChartStyle(),
                              calculations: .none)
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
 BarChartStyle(infoBoxPlacement     : InfoBoxPlacement,
               xAxisGridStyle       : GridStyle,
               yAxisGridStyle       : GridStyle,
               xAxisLabelPosition   : XAxisLabelPosistion,
               xAxisLabelsFrom      : LabelsFrom,
               yAxisLabelPosition   : YAxisLabelPosistion,
               yAxisNumberOfLabels  : Int,
               globalAnimation      : Animation)
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
 
 - Tag: LineChartData
 */
public class MultiBarChartData: BarChartDataProtocol {

    public let id   : UUID  = UUID()

    @Published public var dataSets     : MultiBarDataSet
    @Published public var metadata     : ChartMetadata
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView      : InfoViewData<BarChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text  = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : MultiBarDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
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
        self.setupLegends()
    }
    
    public init(dataSets    : MultiBarDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
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
        self.setupLegends()
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
            let ySection : CGFloat = chartSize.size.height / CGFloat(getMaxValue())
            
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

