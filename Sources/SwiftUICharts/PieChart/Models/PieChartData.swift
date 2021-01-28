//
//  PieChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

public class PieChartData: PieChartDataProtocol {
    
    @Published public var id: UUID = UUID()
    @Published public var dataSets: PieDataSet
    @Published public var metadata: ChartMetadata?
    @Published public var xAxisLabels: [String]?
    @Published public var chartStyle: PieChartStyle
    @Published public var legends: [LegendData]
    @Published public var viewData: ChartViewData<PieChartDataPoint>
    
    public var noDataText: Text
    public var chartType: (chartType: ChartType, dataSetType: DataSetType)
    
    public init(dataSets    : PieDataSet,
                metadata    : ChartMetadata? = nil,
                xAxisLabels : [String]?      = nil,
                chartStyle  : PieChartStyle  = PieChartStyle(),
                noDataText  : Text
    ) {
        self.dataSets    = dataSets
        self.metadata    = metadata
        self.xAxisLabels = xAxisLabels
        self.chartStyle  = chartStyle
        self.legends     = [LegendData]()
        self.viewData    = ChartViewData()
        self.noDataText  = noDataText
        self.chartType   = (chartType: .pie, dataSetType: .single)
    }
    
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
    
    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [PieChartDataPoint] {
        let points : [PieChartDataPoint] = []

        return points
    }
    
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        return [HashablePoint(x: 0, y: 0)]
    }
    
    public func setupLegends() {
        if dataSets.style.colourType == .colour,
           let colour = dataSets.style.colour
        {
            self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                           colour     : colour,
                                           strokeStyle: nil,
                                           prioity    : 1,
                                           chartType  : .bar))
        } else if dataSets.style.colourType == .gradientColour,
                  let colours = dataSets.style.colours
        {
            self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                           colours    : colours,
                                           startPoint : .leading,
                                           endPoint   : .trailing,
                                           strokeStyle: nil,
                                           prioity    : 1,
                                           chartType  : .bar))
        } else if dataSets.style.colourType == .gradientStops,
                  let stops = dataSets.style.stops
        {
            self.legends.append(LegendData(legend     : dataSets.legendTitle,
                                           stops      : stops,
                                           startPoint : .leading,
                                           endPoint   : .trailing,
                                           strokeStyle: nil,
                                           prioity    : 1,
                                           chartType  : .bar))
        }
    }
    
    public typealias Set = PieDataSet
    public typealias DataPoint = PieChartDataPoint
}

public struct PieChartDataPoint: ChartDataPoint {
    
    public var id               : UUID = UUID()
    public var value            : Double
    public var xAxisLabel       : String?
    public var pointDescription : String?
    public var date             : Date?
    
    public var colour           : Color
    
    public init(value           : Double,
                xAxisLabel      : String?   = nil,
                pointDescription: String?   = nil,
                date            : Date?     = nil,
                colour          : Color     = Color.red
    ) {
        self.value              = value
        self.xAxisLabel         = xAxisLabel
        self.pointDescription   = pointDescription
        self.date               = date
        self.colour             = colour
    }
}

public struct PieDataSet: SingleDataSet {

    public var id           : UUID = UUID()
    public var dataPoints   : [PieChartDataPoint]
    public var legendTitle  : String
    public var pointStyle   : PointStyle
    public var style        : PieStyle
    
    public init(dataPoints  : [PieChartDataPoint],
                legendTitle : String,
                pointStyle  : PointStyle,
                style       : PieStyle
    ) {
        self.dataPoints     = dataPoints
        self.legendTitle    = legendTitle
        self.pointStyle     = pointStyle
        self.style          = style
    }

    public typealias Styling = PieStyle
    public typealias DataPoint = PieChartDataPoint
}

public struct PieStyle: CTColourStyle, Hashable {

    public var colourType: ColourType
    public var colour: Color?
    public var colours: [Color]?
    public var stops: [GradientStop]?
    public var startPoint: UnitPoint?
    public var endPoint: UnitPoint?
    
    public init(colour      : Color?          = nil,
                colours     : [Color]?        = nil,
                stops       : [GradientStop]? = nil,
                startPoint  : UnitPoint?      = nil,
                endPoint    : UnitPoint?      = nil
    ) {
        self.colourType     = .colour
        self.colour         = colour
        self.colours        = colours
        self.stops          = stops
        self.startPoint     = startPoint
        self.endPoint       = endPoint
    }
}
