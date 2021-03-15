//
//  LineShape.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

/**
 Main line shape
 */
internal struct LineShape<DP>: Shape where DP: CTStandardDataPointProtocol {
           
    private let dataPoints  : [DP]
    private let lineType    : LineType
    private let isFilled    : Bool
    
    private let minValue : Double
    private let range    : Double
    
<<<<<<< HEAD
    internal init(chartData : ChartData,
=======
    private let ignoreZero: Bool
    
    internal init(dataPoints: [DP],
>>>>>>> version-2
                  lineType  : LineType,
                  isFilled  : Bool,
                  minValue  : Double,
                  range     : Double,
                  ignoreZero: Bool
    ) {
        self.dataPoints = dataPoints
        self.lineType   = lineType
        self.isFilled   = isFilled
<<<<<<< HEAD
        
        switch chartData.lineStyle.baseline {
        case .minimumValue:
            self.minValue = chartData.minValue()
            self.range    = chartData.range()
        case .minimumWithMaximum(of: let value):
            self.minValue = min(chartData.minValue(), value)
            self.range    = chartData.maxValue() - min(chartData.minValue(), value)
        case .zero:
            self.minValue = 0
            self.range    = chartData.maxValue()
        }
    }
  
    internal func path(in rect: CGRect) -> Path {
              
        var path = Path()
                    
            let x : CGFloat = rect.width / CGFloat(chartData.dataPoints.count - 1)
            let y : CGFloat = rect.height / CGFloat(range)
            
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(chartData.dataPoints[0].value - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            
            var previousPoint = firstPoint
            
//            if !chartData.lineStyle.ignoreZero {
                for index in 1 ..< chartData.dataPoints.count - 1 {
                    let nextPoint = CGPoint(x: CGFloat(index) * x,
                                            y: (CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height)
                    lineSwitch(&path, nextPoint, previousPoint)
                    previousPoint = nextPoint
                }
//            } else {
//                for index in 1 ..< chartData.dataPoints.count - 1 {
//                    if chartData.dataPoints[index].value != 0 {
//                        let nextPoint = CGPoint(x: CGFloat(index) * x,
//                                                y: (CGFloat(chartData.dataPoints[index].value - minValue) * -y) + rect.height)
//                        lineSwitch(&path, nextPoint, previousPoint)
//                        previousPoint = nextPoint
//                    }
//                }
//            }
            
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
=======
        self.minValue   = minValue
        self.range      = range
        self.ignoreZero = ignoreZero
    }
  
    internal func path(in rect: CGRect) -> Path {
        switch lineType {
        case .curvedLine:
            return Path.curvedLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled, ignoreZero: ignoreZero)
        case .line:
            return Path.straightLine(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, isFilled: isFilled, ignoreZero: ignoreZero)
        }
>>>>>>> version-2
    }
}

/**
 Background fill based on the upper and lower values
 for a Ranged Line Chart.
 */
internal struct RangedLineFillShape<DP>: Shape where DP: CTRangedLineDataPoint {
           
    private let dataPoints  : [DP]
    private let lineType    : LineType
    
    private var minValue : Double
    private let range    : Double
    
    private let ignoreZero: Bool
    
    internal init(dataPoints: [DP],
                  lineType  : LineType,
                  minValue  : Double,
                  range     : Double,
                  ignoreZero: Bool
    ) {
        self.dataPoints = dataPoints
        self.lineType   = lineType
        self.minValue   = minValue
        self.range      = range
        self.ignoreZero = ignoreZero
    }
  
    internal func path(in rect: CGRect) -> Path {
        
        switch lineType {
        case .curvedLine:
            return  Path.curvedLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, ignoreZero: ignoreZero)
        case .line:
            return  Path.straightLineBox(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range, ignoreZero: ignoreZero)
        }
        
    }
}

