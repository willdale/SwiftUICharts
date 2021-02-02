//
//  LineChartData.swift
//  
//
//  Created by Will Dale on 23/01/2021.
//

import SwiftUI

public class LineChartData: LineChartDataProtocol {
    
    public let id   : UUID  = UUID()
    
    @Published public var dataSets      : LineDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : LineChartStyle
    @Published public var legends       : [LegendData]
    @Published public var viewData      : ChartViewData
    @Published public var isFilled      : Bool = false
    @Published public var infoView      : InfoViewData<LineChartDataPoint> = InfoViewData()
    
    public var noDataText   : Text      = Text("No Data")
    
    public var chartType    : (chartType: ChartType, dataSetType: DataSetType)
            
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata?    = nil,
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
    
    public init(dataSets    : LineDataSet,
                metadata    : ChartMetadata?    = nil,
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
        
        let minValue : Double
        let range    : Double
        
        switch self.chartStyle.baseline {
        case .minimumValue:
            minValue = self.getMinValue()
            range    = self.getRange()
        case .zero:
            minValue = 0
            range    = self.getMaxValue()
        }
            
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
