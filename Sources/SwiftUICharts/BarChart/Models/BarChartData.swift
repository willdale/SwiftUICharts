//
//  File.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a bar chart.
 
 This model contains all the data and styling information for a single data set bar chart.
 
 # Example
 ```
 static func weekOfData() -> BarChartData {
             
     let data : BarDataSet =
         BarDataSet(dataPoints: [
             BarChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
             BarChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
             BarChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
             BarChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
             BarChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
             BarChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
             BarChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
         ],
         legendTitle: "Data",
         pointStyle: PointStyle(),
         style: BarStyle())
     
     let metadata   : ChartMetadata  = ChartMetadata(title       : "Test Data",
                                                     subtitle    : "A weeks worth")
     
     let labels      : [String]      = ["Mon", "Thu", "Sun"]

     let chartStyle  : BarChartStyle = BarChartStyle(infoBoxPlacement: .floating,
                                                        xAxisGridStyle  : GridStyle(),
                                                        yAxisGridStyle  : GridStyle(),
                                                        xAxisLabelPosition: .bottom,
                                                        xAxisLabelsFrom: .dataPoint,
                                                        yAxisLabelPosition: .leading,
                                                        yAxisNumberOfLabels: 5)
     
     return BarChartData(dataSets: data,
                         metadata: metadata,
                         xAxisLabels: labels,
                         chartStyle: chartStyle,
                         calculations: .none)
 }
 
 ```
 
 ---
 
 # Parts
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
 
 - Tag: BarChartData
 */

public class BarChartData: BarChartDataProtocol {

    public let id   : UUID  = UUID()

    @Published public var dataSets     : BarDataSet
    @Published public var metadata     : ChartMetadata
    @Published public var xAxisLabels  : [String]?
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView     : InfoViewData<BarChartDataPoint> = InfoViewData()
        
    public var noDataText   : Text  = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)

    public init(dataSets    : BarDataSet,
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
        self.chartType      = (.bar, .single)
        self.setupLegends()
    }
    
    public init(dataSets    : BarDataSet,
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
        self.chartType      = (chartType: .bar, dataSetType: .single)
        self.setupLegends()
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
        let ySection : CGFloat = chartSize.size.height / CGFloat(self.getMaxValue())
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

    public func setupLegends() {
        switch self.dataSets.style.colourFrom {
        case .barStyle:
            if dataSets.style.colourType == .colour,
               let colour = dataSets.style.colour
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.style.colourType == .gradientColour,
                      let colours = dataSets.style.colours
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if dataSets.style.colourType == .gradientStops,
                      let stops = dataSets.style.stops
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
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
    
    public typealias Set = BarDataSet
    public typealias DataPoint = BarChartDataPoint
    
}
