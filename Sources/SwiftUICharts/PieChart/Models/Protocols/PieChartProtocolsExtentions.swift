//
//  PieChartProtocolExtentions.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

// MARK: - Extentions
extension CTPieDoughnutChartDataProtocol where Set == MultiPieDataSet, DataPoint == MultiPieDataPoint {
    /**
     Sets up the data points in a way that can be sent to renderer for drawing.
     
     It configures each data point with startAngle and amount variables in radians.
     */
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

extension CTPieDoughnutChartDataProtocol {
    public func getPointLocation(dataSet: PieDataSet, touchLocation: CGPoint, chartSize: GeometryProxy) -> CGPoint? {
        return nil
    }
}

extension CTPieDoughnutChartDataProtocol where Set == PieDataSet, DataPoint == PieChartDataPoint {

    /**
     Sets up the data points in a way that can be sent to renderer for drawing.
     
     It configures each data point with startAngle and amount variables in radians.
     */
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
    
    /**
     Gets the number of degrees around the chart from 'north'.
     
     # Reference
     [Atan2](http://www.cplusplus.com/reference/cmath/atan2/)
        
     [Rotate to north](https://stackoverflow.com/a/25398191)
     
     - Parameters:
       - touchLocation: Current location of the touch.
       - rect: The size of the chart view as the parent view.
     - Returns: Degrees around the chart.
     */
    func degree(from touchLocation: CGPoint, in rect: CGRect) -> CGFloat {
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
