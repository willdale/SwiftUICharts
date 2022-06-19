//
//  ExtraLineData.swift
//
//
//  Created by Will Dale on 05/06/2021.
//

import SwiftUI

/**
 Data for drawing and styling the Extra Line view modifier.
 
 This model contains the data and styling information for a single line, line chart.
 */
public struct ExtraLineData: Identifiable {
    
    public let id: UUID = UUID()
    
    public var dataPoints: [ExtraLineDataPoint]
    public var style: ExtraLineStyle
    public var legendTitle: String
    
    public init(
        legendTitle: String,
        dataPoints: () -> ([ExtraLineDataPoint]),
        style: () -> (ExtraLineStyle)
    ) {
        self.dataPoints = dataPoints()
        self.style = style()
        self.legendTitle = legendTitle
        
    }
    
    internal func getTouchInteraction(touchLocation: CGPoint, chartSize: CGRect) -> some View {
        self.markerSubView(dataPoints: dataPoints, lineType: style.lineType, lineSpacing: style.lineSpacing, touchLocation: touchLocation, chartSize: chartSize)
    }
    
    internal func getDataPoint(touchLocation: CGPoint, chartSize: CGRect) -> ExtraLineDataPoint? {
        let xSection: CGFloat = chartSize.width / CGFloat(dataPoints.count)
        let index: Int = Int((touchLocation.x) / xSection)
        if index >= 0 && index < dataPoints.count {
            return dataPoints[index]
        }
        return nil
    }
    
    internal func getPointLocation(touchLocation: CGPoint, chartSize: CGRect) -> CGPoint? {
        
        let minValue: Double = self.minValue
        let range: Double = self.range
        
        let xSection: CGFloat = chartSize.width / CGFloat(dataPoints.count - 1)
        let ySection: CGFloat = chartSize.height / CGFloat(range)
        
        let index: Int = Int((touchLocation.x + (xSection / 2)) / xSection)
        if index >= 0 && index < dataPoints.count {
            return CGPoint(x: CGFloat(index) * xSection,
                           y: (CGFloat(dataPoints[index].value - minValue) * -ySection) + chartSize.height)
        }
        return nil
    }

    internal var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch self.style.baseline {
            case .minimumValue:
                _lowestValue = self.getMinValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(self.getMinValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch self.style.topLine {
            case .maximumValue:
                _highestValue = self.getMaxValue()
            case .maximum(of: let value):
                _highestValue = max(self.getMaxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.00000000001
        }
    }
    internal var minValue: Double {
        get {
            switch self.style.baseline {
            case .minimumValue:
                return self.getMinValue()
            case .minimumWithMaximum(of: let value):
                return min(self.getMinValue(), value)
            case .zero:
                return 0
            }
        }
    }
    internal var maxValue: Double {
        get {
            switch self.style.topLine {
            case .maximumValue:
                return self.getMaxValue()
            case .maximum(of: let value):
                return max(self.getMaxValue(), value)
            }
        }
    }
    internal var average: Double {
        return self.getAverage()
    }
    
    
    internal func getMaxValue() -> Double {
        self.dataPoints
            .map(\.value)
            .max() ?? 0
    }
    internal func getMinValue() -> Double {
        self.dataPoints
            .map(\.value)
            .min() ?? 0
    }
    internal func getAverage() -> Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
            .divide(by: Double(self.dataPoints.count))
    }
}

// MARK: - Position Indicator
extension ExtraLineData {
    /**
     Gets the position on a line relative to where the location of the touch or pointer interaction.
     */
    internal static func getIndicatorLocation(
        rect: CGRect,
        dataPoints: [ExtraLineDataPoint],
        touchLocation: CGPoint,
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        minValue: Double,
        range: Double
    ) -> CGPoint {
        let path = Self.getPath(lineType: lineType,
                                lineSpacing: lineSpacing,
                                rect: rect,
                                dataPoints: dataPoints,
                                minValue: minValue,
                                range: range)
        return Self.locationOnPath(Self.getPercentageOfPath(path: path, touchLocation: touchLocation), path)
    }
}

extension ExtraLineData {
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
        dataPoints: [ExtraLineDataPoint],
        minValue: Double,
        range: Double
    ) -> Path {
        switch (lineType, lineSpacing) {
        case (.curvedLine, .line):
            return Path.extraLineCurved(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
        case (.line, .line):
            return Path.extraLineStraight(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
        case (.curvedLine, .bar):
            return Path.extraLineCurvedBarSpacing(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
        case (.line, .bar):
            return Path.extraLineStraightBarSpacing(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
        case (.stepped, .line):
            return Path.extraLineStepped(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
        case (.stepped, .bar):
            return Path.extraLineSteppedBarSpacing(rect: rect, dataPoints: dataPoints.map(\.value), minValue: minValue, range: range)
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

// MARK: - Markers
extension ExtraLineData {
    
    internal func markerSubView(
        dataPoints: [ExtraLineDataPoint],
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        touchLocation: CGPoint,
        chartSize: CGRect
    ) -> some View {
        Group {
        switch self.style.markerType {
            case .none:
                EmptyView()
            case .indicator(let style):
                
                PosistionIndicator(fillColour: style.fillColour,
                                   lineColour: style.lineColour,
                                   lineWidth: style.lineWidth)
                    .frame(width: style.size, height: style.size)
                    .position(Self.getIndicatorLocation(rect: chartSize,
                                                        dataPoints: dataPoints,
                                                        touchLocation: touchLocation,
                                                        lineType: lineType,
                                                        lineSpacing: lineSpacing,
                                                        minValue: self.minValue,
                                                        range: self.range))
                
            case .vertical(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)

                    Vertical(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:
                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        Vertical(position: position)
                            .stroke(colour, style: style)
                    }
                }

            case .full(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerFull(position: position)
                        .stroke(colour, style: style)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                    
                case .point:
                    
                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerFull(position: position)
                            .stroke(colour, style: style)
                    }
                }

            case .bottomLeading(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)

                    MarkerBottomLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {

                        MarkerBottomLeading(position: position)
                            .stroke(colour, style: style)
                    }
                }

            case .bottomTrailing(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)

                    MarkerBottomTrailing(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {

                        MarkerBottomTrailing(position: position)
                            .stroke(colour, style: style)
                    }
                }

            case .topLeading(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)

                    MarkerTopLeading(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {

                        MarkerTopLeading(position: position)
                            .stroke(colour, style: style)
                    }
                }

            case .topTrailing(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             lineSpacing: lineSpacing,
                                                             minValue: self.minValue,
                                                             range: self.range)

                    MarkerTopTrailing(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(touchLocation: touchLocation,
                                                            chartSize: chartSize) {

                        MarkerTopTrailing(position: position)
                            .stroke(colour, style: style)
                    }
                }
                
            }
        }
    }
}
