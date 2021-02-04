//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct LineShape: Shape {
           
    private let dataPoints  : [LineChartDataPoint]
    /// Drawing style of the line
    private let lineType    : LineType
    private let isFilled    : Bool
    
    private let minValue : Double
    private let range    : Double
    
    internal init(dataPoints: [LineChartDataPoint],
                  lineType  : LineType,
                  isFilled  : Bool,
                  minValue  : Double,
                  range     : Double
    ) {
        self.dataPoints  = dataPoints
        self.lineType   = lineType
        self.isFilled   = isFilled
        self.minValue   = minValue
        self.range      = range
    }
  
    internal func path(in rect: CGRect) -> Path {
                
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        
        switch lineType {
        case .curvedLine:
            return curvedLine(rect, x, y, dataPoints, minValue, range, isFilled)
        case .line:
            return straightLine(rect, x, y, dataPoints, minValue, range, isFilled)
        }
        
    }
}

extension LineShape {
    func straightLine(_ rect        : CGRect,
                      _ x           : CGFloat,
                      _ y           : CGFloat,
                      _ dataPoints  : [LineChartDataPoint],
                      _ minValue    : Double,
                      _ range       : Double,
                      _ isFilled    : Bool
    ) -> Path {
        
        var path = Path()
 
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
                
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index].value - minValue) * -y) + rect.height)
            path.addLine(to: nextPoint)
        }

        if isFilled { filled(&path, rect, x, y, dataPoints) }
        
        return path
    }
    
    func curvedLine(_ rect          : CGRect,
                    _ x             : CGFloat,
                    _ y             : CGFloat,
                    _ dataPoints    : [LineChartDataPoint],
                    _ minValue      : Double,
                    _ range         : Double,
                    _ isFilled      : Bool
    ) -> Path {
        
        var path = Path()
        
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index].value - minValue) * -y) + rect.height)
            
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        if isFilled { filled(&path, rect, x, y, dataPoints) }

        return path
    }
    
    func filled(_ path: inout Path, _ rect: CGRect, _ x : CGFloat, _ y : CGFloat, _ dataPoints: [LineChartDataPoint]) {
        // Draw line straight down
        path.addLine(to: CGPoint(x: CGFloat(dataPoints.count-1) * x,
                                 y: rect.height))
        // Draw line back to start along x axis
        path.addLine(to: CGPoint(x: 0,
                                 y: rect.height))
        // close back to first data point
        path.closeSubpath()
    }
}
