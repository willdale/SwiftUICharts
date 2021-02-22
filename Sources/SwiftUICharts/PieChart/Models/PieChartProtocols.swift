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
public protocol PieAndDoughnutChartDataProtocol: ChartData {}

/**
 A protocol to extend functionality of `PieAndDoughnutChartDataProtocol` specifically for Pie Charts.
 
 # Reference
 [See PieAndDoughnutChartDataProtocol](x-source-tag://PieAndDoughnutChartDataProtocol)
  
 - Tag: PieChartDataProtocol
 */
public protocol PieChartDataProtocol : PieAndDoughnutChartDataProtocol {}

/**
 A protocol to extend functionality of `PieAndDoughnutChartDataProtocol` specifically for  Doughnut Charts.
 
 # Reference
 [See DoughnutChartDataProtocol](x-source-tag://DoughnutChartDataProtocol)
  
 - Tag: DoughnutChartDataProtocol
 */
public protocol DoughnutChartDataProtocol : PieAndDoughnutChartDataProtocol {}

public protocol MultiPieChartDataProtocol : PieAndDoughnutChartDataProtocol {}




// MARK: - DataSet
public protocol CTMultiPieDataSet: DataSet {}

extension PieAndDoughnutChartDataProtocol where Set == MultiPieDataSet, DataPoint == MultiPieDataPoint {
    internal func makeDataPoints() {
        let total       = self.dataSets.dataPoints.reduce(0) { $0 + $1.value }
        var startAngle  = -Double.pi / 2
        
        self.dataSets.dataPoints.indices.forEach { (point) in
            let amount = .pi * 2 * (self.dataSets.dataPoints[point].value / total)
            self.dataSets.dataPoints[point].startAngle  = startAngle
            self.dataSets.dataPoints[point].amount      = amount
 
            
            let layerTotal       = self.dataSets.dataPoints[point].layerDataPoints?.reduce(0) { $0 + $1.value } ?? 0
            var layerStartAngle  = startAngle
            self.dataSets.dataPoints[point].layerDataPoints?.indices.forEach { (layer) in
                let layerValue    =  self.dataSets.dataPoints[point].layerDataPoints?[layer].value ?? 0
                let layerAmount   = amount * (layerValue / layerTotal)
                self.dataSets.dataPoints[point].layerDataPoints?[layer].startAngle  = layerStartAngle
                self.dataSets.dataPoints[point].layerDataPoints?[layer].amount      = layerAmount
                

                
                let layerTwoTotal       = self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?.reduce(0) { $0 + $1.value } ?? 0
                var layerTwoStartAngle  = layerStartAngle
                self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?.indices.forEach { (layerTwo) in
                    let layerTwoValue    = self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].value ?? 0
                    let layerTwoAmount   = layerAmount * (layerTwoValue / layerTwoTotal)
                    self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].startAngle  = layerTwoStartAngle
                    self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].amount      = layerTwoAmount
                    
                    
                    
                    let layerThreeTotal       = self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].layerDataPoints?.reduce(0) { $0 + $1.value } ?? 0
                    var layerThreeStartAngle  = layerTwoStartAngle
                    self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].layerDataPoints?.indices.forEach { (layerThree) in
                        let layerThreeValue    = self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].layerDataPoints?[layerThree].value ?? 0
                        let layerThreeAmount   = layerTwoAmount * (layerThreeValue / layerThreeTotal)
                        self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].layerDataPoints?[layerThree].startAngle  = layerThreeStartAngle
                        self.dataSets.dataPoints[point].layerDataPoints?[layer].layerDataPoints?[layerTwo].layerDataPoints?[layerThree].amount      = layerThreeAmount
                        
                        layerThreeStartAngle += layerThreeAmount
                    }
                    
                    
                    
                    layerTwoStartAngle += layerTwoAmount
                }
                    
                    
                layerStartAngle += layerAmount
            }
            
            startAngle += amount
        }
    }
}


// * (180 / Double.pi)

extension PieAndDoughnutChartDataProtocol where Set == PieDataSet, DataPoint == PieChartDataPoint {

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
    
    internal func setupLegends() {
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




// MARK: - DataPoints

/**
 A protocol to extend functionality of `CTChartDataPoint` specifically for Pie and Doughnut Charts.
 
 Currently empty.
 
 - Tag: CTPieDataPoint
 */
public protocol CTPieDataPoint: CTChartDataPoint {
    var startAngle  : Double { get set }
    var amount      : Double { get set }
}

public protocol CTMultiPieChartDataPoint: CTChartDataPoint {
    var layerDataPoints  : [MultiPieDataPoint]? { get set }
}




// MARK: - Style
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
