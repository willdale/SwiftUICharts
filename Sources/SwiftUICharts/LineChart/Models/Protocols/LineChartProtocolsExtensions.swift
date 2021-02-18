//
//  LineChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Position Indicator
extension LineChartDataProtocol {
    
    public func getIndicatorLocation(rect: CGRect,
                                     dataSet: LineDataSet,
                                     touchLocation: CGPoint
    ) -> CGPoint {
        
        let path = getPath(style        : dataSet.style,
                           rect         : rect,
                           dataPoints   : dataSet.dataPoints,
                           minValue     : self.getMinValue(),
                           range        : self.getRange(),
                           touchLocation: touchLocation,
                           isFilled     : false)
        
        return self.locationOnPath(getPercentageOfPath(path: path, touchLocation: touchLocation), path)
    }
    
    // Maybe put all into extentions of: Path / CGPoint / CGFloat
    // https://developer.apple.com/documentation/swiftui/path/element
    
    /**
     The total length of the path.
     
     - Parameter path: Path to measure.
     - Returns: Total length of the path.
     */
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
    
    /**
     The length from the start of the path to touch location.
     
     - Parameters:
        - touchLocation: Location of the touch or pointer input.
        - path: Path to take measurement from.
     - Returns: Length of path to touch point.
     */
    func getLength(to touchLocation: CGPoint, on path: Path) -> CGFloat {
        var total       : CGFloat = 0
        var currentPoint: CGPoint = .zero
        var isComplete  : Bool    = false
        path.forEach { (element) in
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
                    total += distanceToTouch(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touchLocation.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .curve(to: let nextPoint, control1: _, control2: _ ):
                if touchLocation.x < nextPoint.x {
                    total += distanceToTouch(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touchLocation.x)
                    isComplete = true
                    return
                } else {
                    total += distance(from: currentPoint, to: nextPoint)
                    currentPoint = nextPoint
                }
            case .quadCurve(to: let nextPoint, control: _):
                if touchLocation.x < nextPoint.x {
                    total += distanceToTouch(from  : currentPoint,
                                          to    : nextPoint,
                                          touchX: touchLocation.x)
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
    /**
     Returns the relevent path based on the line type.
     
     - Parameters:
        - style: Styling of the line.
        - rect: Frame the line will be in.
        - dataPoints: Data points to draw the line.
        - minValue: Lowest value in the dataset.
        - range: Difference between the highest and lowest numbers in the dataset.
        - touchLocation: Location of the touch or pointer input.
        - isFilled: Whether it is a normal or filled line.
     - Returns: The relevent path based on the line type
     */
    func getPath(style: LineStyle, rect: CGRect, dataPoints: [LineChartDataPoint], minValue: Double, range: Double, touchLocation: CGPoint, isFilled: Bool) -> Path {
        switch style.lineType {
        case .line:
            return Path.straightLine(rect       : rect,
                                     dataPoints : dataPoints,
                                     minValue   : minValue,
                                     range      : range,
                                     isFilled   : isFilled)
        case .curvedLine:
            return Path.curvedLine(rect       : rect,
                                   dataPoints : dataPoints,
                                   minValue   : minValue,
                                   range      : range,
                                   isFilled   : isFilled)
        }
    }
    
    /**
     How far along the path the touch or pointer is as a percent of the total.
     .
     - Parameters:
        - path: Path being acted on.
        - touchLocation: Location of the touch or pointer input.
     - Returns: How far along the path the touch is.
     */
    func getPercentageOfPath(path: Path, touchLocation: CGPoint) -> CGFloat {
        let totalLength   = self.getTotalLength(of: path)
        let lengthToTouch = self.getLength(to: touchLocation, on: path)
        let pointLocation = lengthToTouch / totalLength
        return pointLocation
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
    func relativePoint(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGPoint {
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
    func distanceToTouch(from: CGPoint, to: CGPoint, touchX: CGFloat) -> CGFloat {
        distance(from: from, to: relativePoint(from: from, to: to, touchX: touchX))
    }

    /**
     Returns the distance between two points.
     
     - Parameters:
        - from: First point
        - to: Second point
     - Returns: Distance between two points.
     */
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    
    // https://swiftui-lab.com/swiftui-animations-part2/
    /**
     Returns a point on the path based on the X axis of the users touch input.
     
     - Parameters:
       - percent: The distance along the path as a percentage.
       - path: Path to find location on.
     - Returns: Point on path.
     */
    func locationOnPath(_ percent: CGFloat, _ path: Path) -> CGPoint {
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
