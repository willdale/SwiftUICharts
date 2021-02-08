//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a single line, line chart.
 
 This model contains all the data and styling information for a single line, line chart.
 
 # Example
 ```
 static func makeData() -> LineChartData {
     
     let data = LineDataSet(dataPoints: [
         LineChartDataPoint(value: 20,  xAxisLabel: "M", pointLabel: "Monday"),
         LineChartDataPoint(value: 90,  xAxisLabel: "T", pointLabel: "Tuesday"),
         LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
         LineChartDataPoint(value: 75,  xAxisLabel: "T", pointLabel: "Thursday"),
         LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
         LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
         LineChartDataPoint(value: 90,  xAxisLabel: "S", pointLabel: "Sunday")
     ],
     legendTitle: "Data",
     pointStyle: PointStyle(),
     style: LineStyle())
     
     let metadata = ChartMetadata(title: "Some Data", subtitle: "A Week")
     
     let labels = ["Monday", "Thursday", "Sunday"]
     
     return LineChartData(dataSets: data,
                          metadata: metadata,
                          xAxisLabels: labels,
                          chartStyle: LineChartStyle(),
                          calculations: .none)
 }
 
 ```
 
 ---
 
 # Parts
 
 ## LineDataSet
 ```
 LineDataSet(dataPoints: [LineChartDataPoint],
                         legendTitle: String,
                         pointStyle: PointStyle,
                         style: LineStyle)
 ```
 ### LineChartDataPoint
 ```
 LineChartDataPoint(value: Double,
                    xAxisLabel: String?,
                    pointLabel: String?,
                    date: Date?)
 ```
 
 ### PointStyle
 ```
 PointStyle(pointSize: CGFloat,
            borderColour: Color,
            fillColour: Color,
            lineWidth: CGFloat,
            pointType: PointType,
            pointShape: PointShape)
 ```
 
 ### LineStyle
 ```
 LineStyle(colour: Color,
           ...)
 
 LineStyle(colours: [Color],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(stops: [GradientStop],
           startPoint: UnitPoint,
           endPoint: UnitPoint,
           ...)
 
 LineStyle(...,
           lineType: LineType,
           strokeStyle: Stroke,
           ignoreZero: Bool)
 ```
 
 ## ChartMetadata
 ```
 ChartMetadata(title: String?, subtitle: String?)
 ```
 
 ## LineChartStyle
 
 ```
 LineChartStyle(infoBoxPlacement    : InfoBoxPlacement,
                xAxisGridStyle      : GridStyle,
                yAxisGridStyle      : GridStyle,
                xAxisLabelPosition  : XAxisLabelPosistion,
                xAxisLabelsFrom     : LabelsFrom,
                yAxisLabelPosition  : YAxisLabelPosistion,
                yAxisNumberOfLabels : Int,
                baseline            : Baseline,
                globalAnimation     : Animation)
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
 - [Line Data Set](x-source-tag://LineDataSet)
    - [Line Chart Data Point](x-source-tag://LineChartDataPoint)
    - [Point Style](x-source-tag://PointStyle)
        - [PointType](x-source-tag://PointType)
        - [PointShape](x-source-tag://PointShape)
    - [Line Style](x-source-tag://LineStyle)
        - [ColourType](x-source-tag://ColourType)
        - [LineType](x-source-tag://LineType)
        - [GradientStop](x-source-tag://GradientStop)
 - [Chart Metadata](x-source-tag://ChartMetadata)
 - [Line Chart Style](x-source-tag://LineChartStyle)
    - [InfoBoxPlacement](x-source-tag://InfoBoxPlacement)
    - [GridStyle](x-source-tag://GridStyle)
    - [XAxisLabelPosistion](x-source-tag://XAxisLabelPosistion)
    - [LabelsFrom](x-source-tag://LabelsFrom)
    - [YAxisLabelPosistion](x-source-tag://YAxisLabelPosistion)

 # Conforms to
 - ObservableObject
 - Identifiable
 - LineChartDataProtocol
 - LineAndBarChartData
 - ChartData
 
 - Tag: LineChartData
 */
public class LineChartData: LineChartDataProtocol {
    
    public let id   : UUID  = UUID()
    
    @Published public var dataSets      : LineDataSet
    @Published public var metadata      : ChartMetadata
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : LineChartStyle
    @Published public var legends       : [LegendData]
    @Published public var viewData      : ChartViewData
    @Published public var isFilled      : Bool = false
    @Published public var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text      = Text("No Data")
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
    
    /// Initialises a Single Line Chart with optional calculation
    ///
    /// Has the option perform optional calculation on the data set, such as averaging based on date.
    ///
    /// - Note:
    /// To add custom calculations use the initialiser with `customCalc`.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - calculations: Addition calculations that can be performed on the data set before drawing.
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                calculations: CalculationType   = .none
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
        self.setupLegends()
    }
    
    /// Initializes a Single Line Chart with custom calculation
    ///
    /// Has the option perform custom calculations on the data set.
    ///
    /// - Note:
    /// To add pre built calculations use the initialiser with `calculations`.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw a line.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - customCalc: Custom calculations that can be performed on the data set before drawing.    
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle = LineChartStyle(),
                customCalc  : @escaping ([LineChartDataPoint]) -> [LineChartDataPoint]?
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
        self.setupLegends()
    }
    
    // MARK: Labels
    // TODO --- Add from xaxis labels
    public func getXAxidLabels() -> some View {
        HStack(spacing: 0) {
            ForEach(dataSets.dataPoints) { data in
                if let label = data.xAxisLabel {
                    Text(label)
                        .font(.caption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                }
                if data != self.dataSets.dataPoints[self.dataSets.dataPoints.count - 1] {
                    Spacer()
                        .frame(minWidth: 0, maxWidth: 500)
                }
            }
        }
        .padding(.horizontal, -4)
    }
    
    // MARK: Touch
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [LineChartDataPoint] {
        var points      : [LineChartDataPoint] = []
        let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            points.append(dataSets.dataPoints[index])
        }
        return points
    }

    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        var locations : [HashablePoint] = []
        
        let minValue : Double = self.getMinValue()
        let range    : Double = self.getRange()
            
        let ySection : CGFloat = chartSize.size.height / CGFloat(range)
        let xSection : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count - 1)
        
        let index    : Int     = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            locations.append(HashablePoint(x: CGFloat(index) * xSection,
                                           y: (CGFloat(dataSets.dataPoints[index].value - minValue) * -ySection) + chartSize.size.height))
        }
        return locations
    }
    // MARK: Legends
    public func setupLegends() {
        
        if dataSets.style.colourType == .colour,
           let colour = dataSets.style.colour
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           colour     : colour,
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))

        } else if dataSets.style.colourType == .gradientColour,
                  let colours = dataSets.style.colours
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           colours    : colours,
                                           startPoint : .leading,
                                           endPoint   : .trailing,
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))

        } else if dataSets.style.colourType == .gradientStops,
                  let stops = dataSets.style.stops
        {
            self.legends.append(LegendData(id         : dataSets.id,
                                           legend     : dataSets.legendTitle,
                                           stops      : stops,
                                           startPoint : .leading,
                                           endPoint   : .trailing,
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
        }
    }
    public typealias Set       = LineDataSet
    public typealias DataPoint = LineChartDataPoint
}
