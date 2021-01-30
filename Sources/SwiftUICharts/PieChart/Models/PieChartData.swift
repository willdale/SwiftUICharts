//
//  PieChartData.swift
//  
//
//  Created by Will Dale on 24/01/2021.
//

import SwiftUI

public class PieChartData: PieChartDataProtocol {
    
    @Published public var id            : UUID = UUID()
    @Published public var dataSets      : PieDataSet
    @Published public var metadata      : ChartMetadata?
    @Published public var xAxisLabels   : [String]?
    @Published public var chartStyle    : PieChartStyle
    @Published public var legends       : [LegendData]
    @Published public var viewData      : ChartViewData<PieChartDataPoint>
        
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
        
        self.setupLegends()
        
        self.makeDataPoints()
    }
    
    internal func makeDataPoints() {
        let total       = self.dataSets.dataPoints.reduce(0) { $0 + $1.value }
        var startAngle  = -Double.pi / 2
        
        self.dataSets.dataPoints.indices.forEach { (point) in
            let amount = .pi * 2 * (self.dataSets.dataPoints[point].value / total)
            self.dataSets.dataPoints[point].amount = amount
            self.dataSets.dataPoints[point].startAngle = startAngle
            startAngle += amount
        }
    }
    
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }

    public func getDataPoint(touchLocation: CGPoint, chartSize: GeometryProxy) -> [PieChartDataPoint] {
        var points : [PieChartDataPoint] = []
        let touchDegree = degree(from: touchLocation, in: chartSize.frame(in: .local))
        let dataPoint = self.dataSets.dataPoints.first(where: { $0.startAngle * Double(180 / Double.pi) <= Double(touchDegree) && ($0.startAngle * Double(180 / Double.pi)) + ($0.amount * Double(180 / Double.pi)) >= Double(touchDegree) } )
        if let data = dataPoint {
            points.append(data)
        }
        return points
    }
    
    public func getPointLocation(touchLocation: CGPoint, chartSize: GeometryProxy) -> [HashablePoint] {
        
        
        return [HashablePoint(x: 0, y: 0)]
    }
    
    public func setupLegends() {
        for data in dataSets.dataPoints {
            if let legend = data.pointDescription {
                self.legends.append(LegendData(legend     : legend,
                                               colour     : data.colour,
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .pie))
            }
        }
    }
    
    
    func degree(from touchLocation: CGPoint, in rect: CGRect) -> CGFloat {
        
        // http://www.cplusplus.com/reference/cmath/atan2/
        // https://stackoverflow.com/a/25398191
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let coordinates = CGPoint(x: touchLocation.x - center.x,
                                  y: touchLocation.y - center.y)
            
        // -90 is north
        let degrees = atan2(-coordinates.x, -coordinates.y) * CGFloat(180 / Double.pi)
        if (degrees > 0) {
            return 270 - degrees
        } else {
            return -90 - degrees
        }

        
        /*
        // Where 0 is north
        let degrees = atan2(-x, -y) * CGFloat(180 / Double.pi)
        if (degrees > 0) {
            return 360 - degrees
        } else {
           return 0 - degrees
        }
        
         Where 0 is East
        var degrees = atan2(y, x) * CGFloat(180 / Double.pi)
        if (degrees < 0) {
            degrees = 360 + degrees
        }
        return degrees
        */
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
    
    var startAngle  : Double = 0
    var amount      : Double = 0
    
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
