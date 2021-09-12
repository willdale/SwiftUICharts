//
//  PositionIndicator.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import SwiftUI

struct PositionIndicator {
    /**
     Gets the position on a line relative to where the location of the touch or pointer interaction.
     */
    internal static func getIndicatorLocation(
        rect: CGRect,
        dataPoints: [Double],
        touchLocation: CGPoint,
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType?,
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) -> CGPoint {
        var path: Path
        if let lineSpacing = lineSpacing {
            path = Self.getPath(lineType: lineType,
                                lineSpacing: lineSpacing,
                                rect: rect,
                                dataPoints: dataPoints,
                                minValue: minValue,
                                range: range)
        } else {
            path = Self.getPath(lineType: lineType,
                                    rect: rect,
                                    dataPoints: dataPoints,
                                    minValue: minValue,
                                    range: range,
                                    isFilled: false,
                                    ignoreZero: ignoreZero)
        }
        return Self.locationOnPath(Self.getPercentageOfPath(path: path, touchLocation: touchLocation), path)
    }
    
    /**
     Returns the relevent path based on the line type.
     
     - Parameters:
      - lineType: Drawing style of the line.
      - rect: Frame the line will be in.
      - dataPoints: Data points to draw the line.
      - minValue: Lowest value in the dataset.
      - range: Difference between the highest and lowest numbers in the dataset.
      - touchLocation: Location of the touch or pointer input.
      - isFilled: Whether it is a normal or filled line.
      - ignoreZero: Whether or not Zeros should be drawn.
     - Returns: The relevent path based on the line type
     */
    static func getPath(
        lineType: LineType,
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double,
        isFilled: Bool,
        ignoreZero: Bool
    ) -> Path {
        switch lineType {
        case .line:
            switch ignoreZero {
            case false:
                return Path.straightLine(rect: rect,
                                         dataPoints: dataPoints,
                                         minValue: minValue,
                                         range: range,
                                         isFilled: isFilled)
            case true:
//                return Path.straightLineIgnoreZero(rect: rect,
//                                                   dataPoints: dataPoints,
//                                                   minValue: minValue,
//                                                   range: range,
//                                                   isFilled: isFilled)
                return Path.straightLine(rect: rect,
                                         dataPoints: dataPoints,
                                         minValue: minValue,
                                         range: range,
                                         isFilled: isFilled)
            }
        case .curvedLine:
            switch ignoreZero {
            case false:
                return Path.curvedLine(rect: rect,
                                       dataPoints: dataPoints,
                                       minValue: minValue,
                                       range: range,
                                       isFilled: isFilled)
            case true:
//                return Path.curvedLineIgnoreZero(rect: rect,
//                                                 dataPoints: dataPoints,
//                                                 minValue: minValue,
//                                                 range: range,
//                                                 isFilled: isFilled)
                return Path.curvedLine(rect: rect,
                                       dataPoints: dataPoints,
                                       minValue: minValue,
                                       range: range,
                                       isFilled: isFilled)
            }
        }
    }
    
    /**
     Returns the relevent path based on the line type.
     
     - Parameters:
        - lineType: Drawing style of the line.
        - rect: Frame the line will be in.
        - dataPoints: Data points to draw the line.
        - minValue: Lowest value in the dataset.
        - range: Difference between the highest and lowest numbers in the dataset.
        - touchLocation: Location of the touch or pointer input.
        - isFilled: Whether it is a normal or filled line.
        - ignoreZero: Whether or not Zeros should be drawn.
     - Returns: The relevent path based on the line type
     */
    static func getPath(
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        switch (lineType, lineSpacing) {
        case (.curvedLine, .line):
            return Path.extraLineCurved(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .line):
            return Path.extraLineStraight(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.curvedLine, .bar):
            return Path.extraLineCurvedBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .bar):
            return Path.extraLineStraightBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
    
    /**
     How far along the path the touch or pointer is as a percent of the total.
     - Parameters:
     - path: Path being acted on.
     - touchLocation: Location of the touch or pointer input.
     - Returns: How far along the path the touch is.
     */
    static func getPercentageOfPath(path: Path, touchLocation: CGPoint) -> CGFloat {
        let totalLength = self.getTotalLength(of: path)
        let lengthToTouch = self.getLength(to: touchLocation, on: path)
        let pointLocation = lengthToTouch / totalLength
        return pointLocation
    }
    
    /**
     The total length of the path.
     
     # Reference
     [Apple](https://developer.apple.com/documentation/swiftui/path/element)
     
     - Parameter path: Path to measure.
     - Returns: Total length of the path.
     */
    static func getTotalLength(of path: Path) -> CGFloat {
        var total: CGFloat = 0
        var currentPoint: CGPoint = .zero
        path.forEach { element in
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
                // No reason for this to fire
                total += 0
            }
        }
        return total
    }
    
    /**
     The length from the start of the path to touch location.
     
     - Parameters:
     - touchLocation: Location of the touch or pointer input.
     - path: Path to take measurement from.
     - Returns: Length of path to touch point.
     */
    static func getLength(to touchLocation: CGPoint, on path: Path) -> CGFloat {
        var total: CGFloat = 0
        var currentPoint: CGPoint = .zero
        var isComplete: Bool = false
        path.forEach { element in
            if isComplete { return }
            switch element {
            case .move(to: let point):
                if touchLocation.x < point.x {
                    isComplete = true
                    return
                } else {
                    currentPoint = point
                }
            case .line(to: let nextPoint):
                if touchLocation.x < nextPoint.x {
                    total += distanceToTouch(from: currentPoint,
                                             to: nextPoint,
                                             touchX: touchLocation.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .curve(to: let nextPoint, control1: _, control2: _ ):
                if touchLocation.x < nextPoint.x {
                    total += distanceToTouch(from: currentPoint,
                                             to: nextPoint,
                                             touchX: touchLocation.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .quadCurve(to: let nextPoint, control: _):
                if touchLocation.x < nextPoint.x {
                    total += distanceToTouch(from: currentPoint,
                                             to: nextPoint,
                                             touchX: touchLocation.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .closeSubpath:
                // No reason for this to fire
                total += 0
                
            }
        }
        return total
    }
    
    /**
     Returns a point on the path based on the location of the touch
     or pointer input on the X axis.
     
     - Parameters:
     - from: First point
     - to: Second point
     - touchX: Location on the X axis of the touch or pointer input.
     - Returns: A point on the path
     */
    static func relativePoint(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGPoint {
        CGPoint(x: touchX,
                y: from.y + (touchX - from.x) * ((to.y - from.y) / (to.x - from.x)))
    }
    
    /**
     Returns the length along the path from a point to the touch locatiions X axis.
     
     - Parameters:
     - from: First point
     - to: Second point
     - touchX: Location on the X axis of the touch or pointer input.
     - Returns: Length from of a path element to touch location
     */
    static func distanceToTouch(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGFloat {
        distance(from: from, to: relativePoint(from: from, to: to, touchX: touchX))
    }
    
    /**
     Returns the distance between two points.
     
     - Parameters:
     - from: First point
     - to: Second point
     - Returns: Distance between two points.
     */
    static func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    
    
    /**
     Returns a point on the path based on the X axis of the users touch input.
     
     # Reference
     [SwiftUI Lab](https://swiftui-lab.com/swiftui-animations-part2/)
     
     - Parameters:
     - percent: The distance along the path as a percentage.
     - path: Path to find location on.
     - Returns: Point on path.
     */
    static func locationOnPath(_ percent: CGFloat, _ path: Path) -> CGPoint {
        // percent difference between points
        let diff: CGFloat = 0.001
        let comp: CGFloat = 1 - diff
        
        // handle limits
        let pct = percent > 1 ? 0 : (percent < 0 ? 1 : percent)
        
        let from = pct > comp ? comp : pct
        let to = pct > comp ? 1 : pct + diff
        let trimmedPoint = path.trimmedPath(from: from, to: to)
        
        return CGPoint(x: trimmedPoint.boundingRect.midX,
                       y: trimmedPoint.boundingRect.midY)
    }
}
