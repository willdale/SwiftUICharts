//
//  PieChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI


// MARK: - Chart Data
/**
 A protocol to extend functionality of `ChartData` specifically for Pie and Doughnut Charts.
 
 # Reference
 [See ChartData](x-source-tag://ChartData)
  
 - Tag: PieAndDoughnutChartDataProtocol
 */
public protocol PieAndDoughnutChartDataProtocol: ChartData {
    associatedtype CTStyle : CTPieAndDoughnutChartStyle
    
    /**
     Protocol to set the styling data for the chart.
     */
    var chartStyle  : CTStyle { get set }
}

/**
 A protocol to extend functionality of `PieAndDoughnutChartDataProtocol` specifically for Pie Charts.
 
 # Reference
 [See PieAndDoughnutChartDataProtocol](x-source-tag://PieAndDoughnutChartDataProtocol)
  
 - Tag: PieChartDataProtocol
 */
public protocol PieChartDataProtocol : PieAndDoughnutChartDataProtocol where CTStyle: CTPieChartStyle {
   
    /**
     Protocol to set the styling data for the chart.
     */
    var chartStyle  : CTStyle { get set }
}

/**
 A protocol to extend functionality of `PieAndDoughnutChartDataProtocol` specifically for  Doughnut Charts.
 
 # Reference
 [See DoughnutChartDataProtocol](x-source-tag://DoughnutChartDataProtocol)
  
 - Tag: DoughnutChartDataProtocol
 */
public protocol DoughnutChartDataProtocol : PieAndDoughnutChartDataProtocol where CTStyle: CTDoughnutChartStyle {
    
    /**
     Protocol to set the styling data for the chart.
     */
    var chartStyle  : CTStyle { get set }
}


// MARK: - Pie and Doughnut
extension PieAndDoughnutChartDataProtocol {
    public func getHeaderLocation() -> InfoBoxPlacement {
        return self.chartStyle.infoBoxPlacement
    }
}
extension PieAndDoughnutChartDataProtocol where Set == PieDataSet {

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
        return [HashablePoint(x: touchLocation.x, y: touchLocation.y)]
    }
    
    public func setupLegends() {
        for data in dataSets.dataPoints {
            if let legend = data.pointDescription {
                self.legends.append(LegendData(id         : data.id,
                                               legend     : legend,
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
    }
}

// MARK: Style
/**
 A protocol to extend functionality of `CTChartStyle` specifically for  Pie and Doughnut Charts.
 
 Currently empty.
 
 - Tag: CTPieAndDoughnutChartStyle
 */
public protocol CTPieAndDoughnutChartStyle: CTChartStyle {}


/**
 A protocol to extend functionality of `CTPieAndDoughnutChartStyle` specifically for  Pie Charts.
 
 Currently empty.
 
 - Tag: CTPieChartStyle
 */
public protocol CTPieChartStyle: CTPieAndDoughnutChartStyle {}


/**
 A protocol to extend functionality of `CTPieAndDoughnutChartStyle` specifically for Doughnut Charts.
  
 - Tag: CTDoughnutChartStyle
 */
public protocol CTDoughnutChartStyle: CTPieAndDoughnutChartStyle {
    
    /**
     Width / Delta of the Doughnut Chart
    */
    var strokeWidth: CGFloat { get set }
}


// MARK: DataPoints

/**
 A protocol to extend functionality of `CTChartDataPoint` specifically for Pie and Doughnut Charts.
 
 Currently empty.
 
 - Tag: CTPieDataPoint
 */
public protocol CTPieDataPoint: CTChartDataPoint {}


