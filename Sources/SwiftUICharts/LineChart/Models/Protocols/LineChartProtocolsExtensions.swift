//
//  LineChartProtocolsExtensions.swift
//
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Box Location
extension CTLineBarChartDataProtocol {
    public func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + (self.viewData.yAxisLabelWidth.max() ?? 0) + self.viewData.yAxisTitleWidth + (self.viewData.hasYAxisLabels ? 4 : 0) // +4 For Padding
    }
}
extension CTLineBarChartDataProtocol where Self: isHorizontal {
    public func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {
        var returnPoint: CGFloat = .zero
        if touchLocation < chartSize.minY + (boxFrame.height / 2) {
            returnPoint = chartSize.minY + (boxFrame.height / 2)
        } else if touchLocation > chartSize.maxY - (boxFrame.height / 2) {
            returnPoint = chartSize.maxY - (boxFrame.height / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint
    }
}

// MARK: - Position Indicator
extension CTLineChartDataProtocol {
    /**
     Gets the position on a line relative to where the location of the touch or pointer interaction.
     */
    internal static func getIndicatorLocation<DP:CTStandardDataPointProtocol & IgnoreMe>(
        rect: CGRect,
        dataPoints: [DP],
        touchLocation: CGPoint,
        lineType: LineType,
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) -> CGPoint {
        let path = Self.getPath(lineType: lineType,
                                rect: rect,
                                dataPoints: dataPoints,
                                minValue: minValue,
                                range: range,
                                isFilled: false,
                                ignoreZero: ignoreZero)
        return Self.locationOnPath(Self.getPercentageOfPath(path: path, touchLocation: touchLocation), path)
    }
}

extension CTLineChartDataProtocol {
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
    static func getPath<DP:CTStandardDataPointProtocol & IgnoreMe>(
        lineType: LineType,
        rect: CGRect,
        dataPoints: [DP],
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
                return Path.straightLineIgnoreZero(rect: rect,
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
                return Path.curvedLineIgnoreZero(rect: rect,
                                                 dataPoints: dataPoints,
                                                 minValue: minValue,
                                                 range: range,
                                                 isFilled: isFilled)
            }
        case .stepped:
            switch ignoreZero {
            case false:
                return Path.steppedLine(rect: rect,
                                       dataPoints: dataPoints,
                                       minValue: minValue,
                                       range: range,
                                       isFilled: isFilled)
            case true:
                return Path.steppedLineIgnoreZero(rect: rect,
                                                 dataPoints: dataPoints,
                                                 minValue: minValue,
                                                 range: range,
                                                 isFilled: isFilled)
            }
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
extension CTLineChartDataProtocol where Self.CTStyle.Mark == LineMarkerType, Self: GetDataProtocol {
    
    internal func markerSubView<DS: CTLineChartDataSet,
                                DP: CTStandardDataPointProtocol & IgnoreMe>(
        dataSet: DS,
        dataPoints: [DP],
        lineType: LineType,
        touchLocation: CGPoint,
        chartSize: CGRect
    ) -> some View {
        Group {
            switch self.chartStyle.markerType {
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
                                                        minValue: self.minValue,
                                                        range: self.range,
                                                        ignoreZero: dataSet.style.ignoreZero))
            case .vertical(attachment: let attach, let colour, let style):

                switch attach {
                case .line(dot: let indicator):

                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    Vertical(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
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
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    MarkerFull(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)


                case .point:

                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
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
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    MarkerBottomLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
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
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    MarkerBottomTrailing(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
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
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    MarkerTopLeading(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
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
                                                             minValue: self.minValue,
                                                             range: self.range,
                                                             ignoreZero: dataSet.style.ignoreZero)

                    MarkerTopTrailing(position: position)
                        .stroke(colour, style: style)

                    IndicatorSwitch(indicator: indicator, location: position)

                case .point:

                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {

                        MarkerTopTrailing(position: position)
                            .stroke(colour, style: style)
                    }
                }
            }
        }
    }
}

/**
 Sub view for laying out and styling the indicator dot.
 */
internal struct IndicatorSwitch: View {
    
    private let indicator: Dot
    private let location: CGPoint
    
    internal init(indicator: Dot, location: CGPoint) {
        self.indicator = indicator
        self.location = location
    }
    
    internal var body: some View {
        switch indicator {
        case .none: EmptyView()
        case .style(let style):
            PosistionIndicator(fillColour: style.fillColour,
                               lineColour: style.lineColour,
                               lineWidth: style.lineWidth)
                .frame(width: style.size, height: style.size)
                .position(location)
        }
    }
    
}

// MARK: - Legends
extension CTLineChartDataProtocol where Self.SetType.ID == UUID,
                                        Self.SetType: CTLineChartDataSet {
    internal func setupLegends() {
        lineLegendSetup(dataSet: dataSets)
    }
}

extension CTLineChartDataProtocol where Self.SetType == MultiLineDataSet {
    internal func setupLegends() {
        dataSets.dataSets.forEach { lineLegendSetup(dataSet: $0) }
    }
}

extension CTLineChartDataProtocol {
    internal func lineLegendSetup<DS: CTLineChartDataSet>(dataSet: DS) where DS.ID == UUID {
        if dataSet.style.lineColour.colourType == .colour,
           let colour = dataSet.style.lineColour.colour
        {
            self.legends.append(LegendData(id: dataSet.id,
                                           legend: dataSet.legendTitle,
                                           colour: ColourStyle(colour: colour),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .line))
        } else if dataSet.style.lineColour.colourType == .gradientColour,
                  let colours = dataSet.style.lineColour.colours
        {
            self.legends.append(LegendData(id: dataSet.id,
                                           legend: dataSet.legendTitle,
                                           colour: ColourStyle(colours: colours,
                                                               startPoint: .leading,
                                                               endPoint: .trailing),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .line))
        } else if dataSet.style.lineColour.colourType == .gradientStops,
                  let stops = dataSet.style.lineColour.stops
        {
            self.legends.append(LegendData(id: dataSet.id,
                                           legend: dataSet.legendTitle,
                                           colour: ColourStyle(stops: stops,
                                                               startPoint: .leading,
                                                               endPoint: .trailing),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .line))
        }
    }
}

extension CTLineChartDataProtocol where Self.SetType.ID == UUID,
                                        Self.SetType: CTRangedLineChartDataSet,
                                        Self.SetType.Styling: CTRangedLineStyle {
    internal func setupRangeLegends() {
        if dataSets.style.fillColour.colourType == .colour,
           let colour = dataSets.style.fillColour.colour
        {
            self.legends.append(LegendData(id: UUID(),
                                           legend: dataSets.legendFillTitle,
                                           colour: ColourStyle(colour: colour),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .bar))
        } else if dataSets.style.fillColour.colourType == .gradientColour,
                  let colours = dataSets.style.fillColour.colours
        {
            self.legends.append(LegendData(id: UUID(),
                                           legend: dataSets.legendFillTitle,
                                           colour: ColourStyle(colours: colours,
                                                               startPoint: .leading,
                                                               endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .bar))
        } else if dataSets.style.fillColour.colourType == .gradientStops,
                  let stops = dataSets.style.fillColour.stops
        {
            self.legends.append(LegendData(id: UUID(),
                                           legend: dataSets.legendFillTitle,
                                           colour: ColourStyle(stops: stops,
                                                               startPoint: .leading,
                                                               endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity: 1,
                                           chartType: .bar))
        }
    }
}

// MARK: - Accessibility
extension CTLineChartDataProtocol where SetType: CTLineChartDataSet {
    public func getAccessibility() -> some View {
        ForEach(dataSets.dataPoints.indices, id: \.self) { point in
            
            AccessibilityRectangle(dataPointCount: self.dataSets.dataPoints.count,
                                   dataPointNo: point)
                
                .foregroundColor(Color(.gray).opacity(0.000000001))
                .accessibilityLabel(LocalizedStringKey(self.metadata.title))
                .accessibilityValue(self.dataSets.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier,
                                                                                              formatter: self.infoView.touchFormatter))
        }
    }
}
