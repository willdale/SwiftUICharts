//
//  LineChartProtocols.swift
//  
//
//  Created by Will Dale on 02/02/2021.
//

import SwiftUI

/**
 A protocol to extend functionality of `LineAndBarChartData` specifically for Line Charts.
 
 # Reference
 [See LineAndBarChartData](x-source-tag://LineAndBarChartData)
 
 `LineAndBarChartData` conforms to [ChartData](x-source-tag://ChartData)
 
 - Tag: LineChartDataProtocol
 */
public protocol LineChartDataProtocol: LineAndBarChartData where CTStyle: CTLineChartStyle {
    var chartStyle  : CTStyle { get set }
    var isFilled    : Bool { get set}
    
    func straightLine(rect: CGRect, dataPoints: [LineChartDataPoint], minValue: Double, range: Double, isFilled: Bool) -> Path
    func curvedLine(rect: CGRect, dataPoints: [LineChartDataPoint], minValue: Double, range: Double, isFilled: Bool) -> Path
    
    func locationOnPath(_ percent: CGFloat, _ path: Path) -> CGPoint
}

// MARK: - Paths
extension LineChartDataProtocol {
    
    public func straightLine(rect: CGRect, dataPoints: [LineChartDataPoint], minValue: Double, range: Double, isFilled: Bool) -> Path {
        
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        
        var path = Path()
 
        let firstPoint = CGPoint(x: 0,
                                 y: (CGFloat(dataPoints[0].value - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
                
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index].value - minValue) * -y) + rect.height)
            path.addLine(to: nextPoint)
        }
        
        if isFilled {
            path.addLine(to: CGPoint(x: CGFloat(dataPoints.count-1) * x,
                                     y: rect.height))
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            path.closeSubpath()
        }
        
        return path
    }
    
    public func curvedLine(rect: CGRect, dataPoints: [LineChartDataPoint], minValue: Double, range: Double, isFilled: Bool) -> Path {
        
        let x : CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y : CGFloat = rect.height / CGFloat(range)
        
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
        
        if isFilled {
            // Draw line straight down
            path.addLine(to: CGPoint(x: CGFloat(dataPoints.count-1) * x,
                                     y: rect.height))
            // Draw line back to start along x axis
            path.addLine(to: CGPoint(x: 0,
                                     y: rect.height))
            // close back to first data point
            path.closeSubpath()
        }

        return path
    }
    
    // MARK: - position indicator
    // Maybe put all into extentions of: Path / CGPoint / CGFloat
    public func getTotalLength(of path: Path) -> CGFloat {
        var total       : CGFloat = 0
        var currentPoint: CGPoint = .zero
        path.forEach { (element) in
            switch element {
            case .move(to: let first):
                currentPoint = first
            case .line(to: let next):
                total += distance(from: currentPoint, to: next)
                currentPoint = next
            case .curve(to: let next, control1: _, control2: _):
                total += distance(from: currentPoint, to: next)
                currentPoint = next
            case .quadCurve(to: let next, control: _):
                total += distance(from: currentPoint, to: next)
                currentPoint = next
            case .closeSubpath:
                print("No reason for this to fire")
            
            }
        }
        return total
    }
    public func getLength(to touch: CGPoint, on path: Path) -> CGFloat {
        var total       : CGFloat = 0
        var currentPoint: CGPoint = .zero
        var isComplete  : Bool    = false
        path.forEach { (element) in
            if isComplete {
                return
            }
            switch element {
            case .move(to: let point):
                if touch.x < point.x {
                    isComplete = true
                    return
                } else {
                    currentPoint = point
                }
            case .line(to: let nextPoint):
                if touch.x < nextPoint.x {
                    total += lineDistance(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touch.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .curve(to: let nextPoint, control1: _, control2: _ ):
                if touch.x < nextPoint.x {
                    total += lineDistance(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touch.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .quadCurve(to: let nextPoint, control: _):
                if touch.x < nextPoint.x {
                    total += lineDistance(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touch.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .closeSubpath:
                print("No reason for this to fire")
                
            }
        }
        return total
    }
    
    
    func relativePoint(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGPoint {
        CGPoint(x: touchX,
                y: from.y + (touchX - from.x) * ((to.y - from.y) / (to.x - from.x)))
    }

    func lineDistance(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGFloat {
        distance(from: from, to: relativePoint(from: from, to: to, touchX: touchX))
    }

    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    
    // https://swiftui-lab.com/swiftui-animations-part2/
    public func locationOnPath(_ percent: CGFloat, _ path: Path) -> CGPoint {
        // percent difference between points
        let diff: CGFloat = 0.001
        let comp: CGFloat = 1 - diff
        
        // handle limits
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
        
        let from = pct > comp ? comp : pct
        let to   = pct > comp ? 1 : pct + diff
        let trimmedPoint = path.trimmedPath(from: from, to: to)
        
        return CGPoint(x: trimmedPoint.boundingRect.midX,
                       y: trimmedPoint.boundingRect.midY)
    }
}

extension LineAndBarChartData where Self: LineChartDataProtocol {
    public func getYLabels() -> [Double] {
        var labels      : [Double]  = [Double]()
        let dataRange   : Double = self.getRange()
        let minValue    : Double = self.getMinValue()
        let range       : Double = dataRange / Double(self.chartStyle.yAxisNumberOfLabels)

        labels.append(minValue)
        for index in 1...self.chartStyle.yAxisNumberOfLabels {
            labels.append(minValue + range * Double(index))
        }
        return labels
    }
}


extension LineAndBarChartData where Self: LineChartData {
    public func getRange() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.dataSetMaxValue(from: dataSets) - min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.dataSetMaxValue(from: dataSets)
        }
    }
    public func getMinValue() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.dataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.dataSetMinValue(from: dataSets), value)
        case .zero:
           return 0
        }
    }
}
extension LineAndBarChartData where Self: MultiLineChartData {
    public func getRange() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetRange(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return DataFunctions.multiDataSetMaxValue(from: dataSets) - min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
            return DataFunctions.multiDataSetMaxValue(from: dataSets)
        }
    }
    public func getMinValue() -> Double {
        switch self.chartStyle.baseline {
        case .minimumValue:
            return DataFunctions.multiDataSetMinValue(from: dataSets)
        case .minimumWithMaximum(of: let value):
            return min(DataFunctions.multiDataSetMinValue(from: dataSets), value)
        case .zero:
           return 0
        }
    }
}

/**
 A protocol to extend functionality of `CTLineAndBarChartStyle` specifically for  Line Charts.
 
 - Tag: CTLineChartStyle
 */
public protocol CTLineChartStyle : CTLineAndBarChartStyle {
    /**
     Where to start drawing the line chart from. Zero or data set minium.
     
     [See Baseline](x-source-tag://Baseline)
     */
    var baseline: Baseline { get set }
}
