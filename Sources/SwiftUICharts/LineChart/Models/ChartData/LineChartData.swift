//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

/**
 Data for drawing and styling a single line, line chart.
 
 This model contains the data and styling information for a single line, line chart.
 
 # Example
 ```
 static func weekOfData() -> LineChartData {
     
     let data = LineDataSet(dataPoints: [
         LineChartDataPoint(value: 120, xAxisLabel: "M", pointLabel: "Monday"),
         LineChartDataPoint(value: 190, xAxisLabel: "T", pointLabel: "Tuesday"),
         LineChartDataPoint(value: 100, xAxisLabel: "W", pointLabel: "Wednesday"),
         LineChartDataPoint(value: 175, xAxisLabel: "T", pointLabel: "Thursday"),
         LineChartDataPoint(value: 160, xAxisLabel: "F", pointLabel: "Friday"),
         LineChartDataPoint(value: 110, xAxisLabel: "S", pointLabel: "Saturday"),
         LineChartDataPoint(value: 190, xAxisLabel: "S", pointLabel: "Sunday")
     ],
     legendTitle: "Test One",
     pointStyle: PointStyle(),
     style: LineStyle(colour: Color.red, lineType: .curvedLine))
          
     return LineChartData(dataSets       : data,
                          metadata       : ChartMetadata(title: "Some Data", subtitle: "A Week"),
                          xAxisLabels    : ["Monday", "Thursday", "Sunday"],
                          chartStyle     : LineChartStyle(infoBoxPlacement    : .floating,
                                                          markerType          : .indicator(style: DotStyle()),
                                                          xAxisLabelPosition  : .bottom,
                                                          xAxisLabelsFrom     : .chartData,
                                                          yAxisLabelPosition  : .leading,
                                                          yAxisNumberOfLabels : 7,
                                                          baseline            : .minimumWithMaximum(of: 80),
                                                          globalAnimation     : .easeOut(duration: 1)))
 }
 
 ```
 */
public final class LineChartData: CTLineChartDataProtocol {
    
    // MARK: Properties
    public let id   : UUID  = UUID()
    
    @Published public var dataSets      : LineDataSet
    @Published public var metadata      : ChartMetadata
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : LineChartStyle
    @Published public var legends       : [LegendData]
    @Published public var viewData      : ChartViewData
    @Published public var isFilled      : Bool = false
    @Published public var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
        
    // MARK: Initializer
    /// Initialises a Single Line Chart.
    ///
    /// - Parameters:
    ///   - dataSets: Data to draw and style a line.
    ///   - metadata: Data model containing the charts Title, Subtitle and the Title for Legend.
    ///   - xAxisLabels: Labels for the X axis instead of the labels in the data points.
    ///   - chartStyle: The style data for the aesthetic of the chart.
    ///   - noDataText: Customisable Text to display when where is not enough data to draw the chart.
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata     = ChartMetadata(),
                xAxisLabels : [String]?         = nil,
                chartStyle  : LineChartStyle    = LineChartStyle(),
                noDataText  : Text              = Text("No Data")
    ) {
        self.dataSets       = dataSets
        self.metadata       = metadata
        self.xAxisLabels    = xAxisLabels
        self.chartStyle     = chartStyle
        self.noDataText     = noDataText
        self.legends        = [LegendData]()
        self.viewData       = ChartViewData()
        self.chartType      = (chartType: .line, dataSetType: .single)
        self.setupLegends()
    }
    // , calc        : @escaping (LineDataSet) -> LineDataSet
    
    // MARK: Labels
    public func getXAxisLabels() -> some View {
        Group {
            switch self.chartStyle.xAxisLabelsFrom {
            case .dataPoint:
                
                HStack(spacing: 0) {
                    ForEach(dataSets.dataPoints) { data in
                        if let label = data.xAxisLabel {
                            Text(label)
                                .font(.caption)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
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
                
            case .chartData:
                if let labelArray = self.xAxisLabels {
                    HStack(spacing: 0) {
                        ForEach(labelArray, id: \.self) { data in
                            Text(data)
                                .font(.caption)
                                .foregroundColor(self.chartStyle.xAxisLabelColour)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            if data != labelArray[labelArray.count - 1] {
                                Spacer()
                                    .frame(minWidth: 0, maxWidth: 500)
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                }
            }
        }
    }
    
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double = self.minValue
        let minValue    : Double = self.range
        let range       : Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)

        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }

    // MARK: Points
    public func getPointMarker() -> some View {
        PointsSubView(dataSets  : dataSets,
                      minValue  : self.minValue,
                      range     : self.range,
                      animation : self.chartStyle.globalAnimation,
                      isFilled  : self.isFilled)
    }
    
    // MARK: Touch
    public func setTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) {
        self.infoView.isTouchCurrent   = true
        self.infoView.touchLocation    = touchLocation
        self.infoView.chartSize        = chartSize.frame(in: .local)
        self.getDataPoint(touchLocation: touchLocation, chartSize: chartSize)
    }
    
    

    public func getTouchInteraction(touchLocation: CGPoint, chartSize: GeometryProxy) -> some View {
        self.markerSubView(dataSet: self.dataSets, touchLocation: touchLocation, chartSize: chartSize)
    }

    public typealias Set       = LineDataSet
    public typealias DataPoint = LineChartDataPoint
}

// MARK: - Touch
extension LineChartData: TouchProtocol {
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) {
        var points      : [LineChartDataPoint] = []
        let xSection    : CGFloat = chartSize.size.width / CGFloat(dataSets.dataPoints.count - 1)
        let index       = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataSets.dataPoints.count {
            points.append(dataSets.dataPoints[index])
        }
        self.infoView.touchOverlayInfo = points
    }
}

// MARK: - Legends
extension LineChartData: LegendProtocol {
   
    internal func setupLegends() {
        
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

    internal func legendOrder() -> [LegendData] {
        return legends.sorted { $0.prioity < $1.prioity}
    }
}
