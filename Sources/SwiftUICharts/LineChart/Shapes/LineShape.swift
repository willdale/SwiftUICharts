//
//  Line.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct LineShape: Shape {
           
    private let chartData   : ChartData
        
    /// Drawing style of the line
    private let lineType    : LineType
    /// If it's to be filled some extra lines need to be drawn
    private let isFilled    : Bool
    
    internal init(chartData : ChartData,
                  lineType  : LineType,
                  isFilled  : Bool
    ) {
        self.chartData  = chartData
        self.lineType   = lineType
        self.isFilled   = isFilled
    }
  
    internal func path(in rect: CGRect) -> Path {
        
        let minValue: Double = chartData.minValue()
        let range   : Double =  chartData.range()
        
        var path = Path()
        
        let x : CGFloat = rect.width / CGFloat(chartData.dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
            
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(chartData.dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)

        var previousPoint = firstPoint
        
        if !chartData.chartStyle.ignoreZero {
            for index in 1 ..< chartData.dataPoints.count - 1 {
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height)
                lineSwitch(&path, nextPoint, previousPoint)
                previousPoint = nextPoint
            }
        } else {
            for index in 1 ..< chartData.dataPoints.count - 1 {
                if chartData.dataPoints[index].value != 0 {
                    let nextPoint = CGPoint(x: CGFloat(index) * x,
                                            y: (CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height)
                    lineSwitch(&path, nextPoint, previousPoint)
                    previousPoint = nextPoint
                }
            }
        }
        
        let lastPoint = CGPoint(x: CGFloat(chartData.dataPoints.count-1) * x,
                                y: (CGFloat(chartData.dataPoints[chartData.dataPoints.count-1].value - minValue) * -y) + rect.height)
        lineSwitch(&path, lastPoint, previousPoint)
        
        if isFilled {
            // Draw line straight down
            path.addLine(to: CGPoint(x: CGFloat(chartData.dataPoints.count-1) * x,
                                     y: rect.height))
            // Draw line back to start along x axis
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            // close back to first data point
            path.closeSubpath()
        }

        return path
    }

    internal func lineSwitch(_ path: inout Path, _ nextPoint: CGPoint, _ previousPoint: CGPoint) {
        switch lineType {
        case .line:
            path.addLine(to: nextPoint)
        case .curvedLine:
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
        }
    }
}

/**
 Drawing style of the line
 ```
 case line // Straight line from point to point
 case curvedLine // Dual control point curved line
 ```
 */
public enum LineType {
    /// Straight line from point to point
    case line
    /// Dual control point curved line
    case curvedLine
}
