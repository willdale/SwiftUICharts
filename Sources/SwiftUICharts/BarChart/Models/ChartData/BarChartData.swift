//
//  BarChartData.swift
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
     
     return BarChartData(dataSets    : data,
                         metadata    : metadata,
                         xAxisLabels : labels,
                         chartStyle  : chartStyle,
                         noDataText  : Text("No Data"),
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

public final class BarChartData: BarChartDataProtocol {
    // MARK: - Properties
    public let id   : UUID  = UUID()

    @Published public var dataSets     : BarDataSet
    @Published public var metadata     : ChartMetadata
    @Published public var xAxisLabels  : [String]?
    @Published public var barStyle     : BarStyle
    @Published public var chartStyle   : BarChartStyle
    @Published public var legends      : [LegendData]
    @Published public var viewData     : ChartViewData
    @Published public var infoView     : InfoViewData<BarChartDataPoint> = InfoViewData()
        
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    // MARK: - Initializers
    /// Initialises a standard Bar Chart with optional calculation
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style the bars.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : BarDataSet,
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
        self.chartType      = (.bar, .single)
        self.setupLegends()
    }

    // MARK: - Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:
          
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
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
    }
    
    // MARK: - Touch
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
    
    public func touchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View {
        let positions = self.getPointLocation(touchLocation: touchLocation,
                                              chartSize: chartSize)
        return ZStack {
            ForEach(positions, id: \.self) { position in
                
                switch self.chartStyle.markerType {
                case .none:
                    EmptyView()
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
        
        switch self.barStyle.colourFrom {
        case .barStyle:
            if self.barStyle.colourType == .colour,
               let colour = self.barStyle.colour
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colour     : colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.colourType == .gradientColour,
                      let colours = self.barStyle.colours
            {
                self.legends.append(LegendData(id         : dataSets.id,
                                               legend     : dataSets.legendTitle,
                                               colours    : colours,
                                               startPoint : .leading,
                                               endPoint   : .trailing,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .bar))
            } else if self.barStyle.colourType == .gradientStops,
                      let stops = self.barStyle.stops
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
    
    public typealias Set            = BarDataSet
    public typealias DataPoint      = BarChartDataPoint
    public typealias CTStyle        = BarChartStyle
}
