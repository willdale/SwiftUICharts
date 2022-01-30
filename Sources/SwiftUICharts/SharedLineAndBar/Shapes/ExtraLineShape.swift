//
//  ExtraLineShape.swift
//
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

internal struct ExtraLineShape: Shape {
    
    private let dataPoints: [Double]
    private let lineType: LineType
    private let lineSpacing: ExtraLineStyle.SpacingType
    private let range: Double
    private let minValue: Double
    
    internal init(
        dataPoints: [Double],
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        range: Double,
        minValue: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch (lineType, lineSpacing) {
        case (.curvedLine, .line):
            return Path.extraLineCurved(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .line):
            return Path.extraLineStraight(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.curvedLine, .bar):
            return Path.extraLineCurvedBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .bar):
            return Path.extraLineStraightBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.stepped, .line):
            return Path.extraLineStepped(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.stepped, .bar):
            return Path.extraLineSteppedBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

// MARK: - Paths
//
//
//
// MARK: - Line Spacing
extension Path {
    static func extraLineStraight(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            for index in 1 ..< dataPoints.count {
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    static func extraLineCurved(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPoint: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        return path
    }
    
    static func extraLineStepped(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            var newPoint = firstPoint
            for index in 1 ..< dataPoints.count {
                let nextStep = CGPoint(x: CGFloat(index) * x,
                                       y: newPoint.y)
                path.addLine(to: nextStep)
                newPoint = CGPoint(x: CGFloat(index) * x,
                                   y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: newPoint)
            }
        }
        return path
    }
}

// MARK: - Bar Spacing
extension Path {
    static func extraLineStraightBarSpacing(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0 + (x / 2),
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            for index in 1 ..< dataPoints.count {
                let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                        y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    static func extraLineCurvedBarSpacing(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPointOne: CGPoint = CGPoint(x: 0,
                                             y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.move(to: firstPointOne)
        
        let firstPointTwo: CGPoint = CGPoint(x: 0 + (x / 2),
                                             y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.addLine(to: firstPointTwo)
        
        var previousPoint = firstPointTwo
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                    y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        let lastPoint: CGPoint = CGPoint(x: (CGFloat(dataPoints.count) * x),
                                         y: (CGFloat(dataPoints[dataPoints.count - 1] - minValue) * -y) + rect.height)
        path.addLine(to: lastPoint)
        
        return path
    }
    
    static func extraLineSteppedBarSpacing(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0 + (x / 2),
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            var newPoint = firstPoint
            for index in 1 ..< dataPoints.count {
                let nextStep = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                       y: newPoint.y)
                path.addLine(to: nextStep)
                newPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                   y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: newPoint)
            }
        }
        return path
    }
}

