//
//  PieChartProtocolExtentions.swift
//  
//
//  Created by Will Dale on 23/02/2021.
//

import SwiftUI

// MARK: - Extentions

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

extension CTPieDoughnutChartDataProtocol where Self.Set.DataPoint.ID == UUID,
                                               Self.Set: CTSingleDataSetProtocol,
                                               Self.Set.DataPoint: CTPieDataPoint {
    internal func setupLegends() {
        for data in dataSets.dataPoints {
            if let legend = data.pointDescription {
                self.legends.append(LegendData(id         : data.id,
                                               legend     : legend,
                                               colour     : ColourStyle(colour: data.colour),
                                               strokeStyle: nil,
                                               prioity    : 1,
                                               chartType  : .pie))
            }
        }
    }
}
