//
//  LineChartProtocolsExtensions.swift
//  
//
//  Created by Will Dale on 13/02/2021.
//

import SwiftUI

// MARK: - Position Indicator
extension CTLineChartDataProtocol {
    
    public static func getIndicatorLocation<DP:CTStandardDataPointProtocol>(rect: CGRect,
                                                                            dataPoints: [DP],
                                                                            touchLocation: CGPoint,
                                                                            lineType: LineType,
                                                                            minValue: Double,
                                                                            range: Double
    ) -> CGPoint {
        
        let path = Self.getPath(lineType     : lineType,
                                rect         : rect,
                                dataPoints   : dataPoints,
                                minValue     : minValue,
                                range        : range,
                                touchLocation: touchLocation,
                                isFilled     : false)
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
     - Returns: The relevent path based on the line type
     */
   static func getPath<DP:CTStandardDataPointProtocol>(lineType: LineType, rect: CGRect, dataPoints: [DP], minValue: Double, range: Double, touchLocation: CGPoint, isFilled: Bool) -> Path {
        switch lineType {
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
    static func getPercentageOfPath(path: Path, touchLocation: CGPoint) -> CGFloat {
        let totalLength   = self.getTotalLength(of: path)
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
        let to   = pct > comp ? 1 : pct + diff
        let trimmedPoint = path.trimmedPath(from: from, to: to)
        
        return CGPoint(x: trimmedPoint.boundingRect.midX,
                       y: trimmedPoint.boundingRect.midY)
    }
}

// MARK: - Markers
extension CTLineChartDataProtocol where Self.CTStyle.Mark == LineMarkerType {

    internal func markerSubView<DS: CTDataSetProtocol,
                                DP: CTStandardDataPointProtocol>
    (dataSet         : DS,
     dataPoints      : [DP],
     lineType        : LineType,
     touchLocation   : CGPoint,
     chartSize       : CGRect) -> some View {
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
                                                        range: self.range))
                
            case .vertical(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    Vertical(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        Vertical(position: position)
                            .stroke(Color.primary, lineWidth: 2)
                    }
                }
                
            case .full(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerFull(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerFull(position: position)
                            .stroke(Color.primary, lineWidth: 2)
                    }
                }
                
            case .bottomLeading(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerBottomLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerBottomLeading(position: position)
                            .stroke(Color.primary, lineWidth: 2)
                    }
                }
                
            case .bottomTrailing(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerBottomTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerBottomTrailing(position: position)
                            .stroke(Color.primary, lineWidth: 2)
                    }
                }
                
            case .topLeading(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerTopLeading(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerTopLeading(position: position)
                            .stroke(Color.primary, lineWidth: 2)
                    }
                }
                
            case .topTrailing(attachment: let attach):
                
                switch attach {
                case .line(dot: let indicator):
                    
                    let position = Self.getIndicatorLocation(rect: chartSize,
                                                             dataPoints: dataPoints,
                                                             touchLocation: touchLocation,
                                                             lineType: lineType,
                                                             minValue: self.minValue,
                                                             range: self.range)
                    
                    MarkerTopTrailing(position: position)
                        .stroke(Color.primary, lineWidth: 2)
                    
                    IndicatorSwitch(indicator: indicator, location: position)
                    
                case .point:
                    
                    if let position = self.getPointLocation(dataSet: dataSet as! Self.SetPoint,
                                                            touchLocation: touchLocation,
                                                            chartSize: chartSize) {
                        
                        MarkerTopTrailing(position: position)
                            .stroke(Color.primary, lineWidth: 2)
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
    private let location : CGPoint
    
    internal init(indicator: Dot, location: CGPoint) {
        self.indicator = indicator
        self.location = location
    }
    
    internal var body: some View {
        switch indicator {
        case .none: EmptyView()
        case .style(let style):
            PosistionIndicator(fillColour: style.fillColour, lineColour: style.lineColour, lineWidth: style.lineWidth)
                .frame(width: style.size, height: style.size)
                .position(location)
        }
    }
    
}

// MARK: - Legends
extension CTLineChartDataProtocol where Self.Set.ID == UUID,
                                        Self.Set : CTLineChartDataSet {
    internal func setupLegends() {
        lineLegendSetup(dataSet: dataSets)
    }
}

extension CTLineChartDataProtocol where Self.Set == MultiLineDataSet {
    internal func setupLegends() {
        for dataSet in dataSets.dataSets {
            lineLegendSetup(dataSet: dataSet)
        }
    }
}
extension CTLineChartDataProtocol {
    internal func lineLegendSetup<DS: CTLineChartDataSet>(dataSet: DS) where DS.ID == UUID {
        if dataSet.style.lineColour.colourType == .colour,
           let colour = dataSet.style.lineColour.colour
        {
            self.legends.append(LegendData(id         : dataSet.id,
                                           legend     : dataSet.legendTitle,
                                           colour     : ColourStyle(colour: colour),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
            
        } else if dataSet.style.lineColour.colourType == .gradientColour,
                  let colours = dataSet.style.lineColour.colours
        {
            self.legends.append(LegendData(id         : dataSet.id,
                                           legend     : dataSet.legendTitle,
                                           colour     : ColourStyle(colours: colours,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
            
        } else if dataSet.style.lineColour.colourType == .gradientStops,
                  let stops = dataSet.style.lineColour.stops
        {
            self.legends.append(LegendData(id         : dataSet.id,
                                           legend     : dataSet.legendTitle,
                                           colour     : ColourStyle(stops: stops,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                           strokeStyle: dataSet.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .line))
        }
    }
}
extension CTLineChartDataProtocol where Self.Set.ID == UUID,
                                        Self.Set: CTRangedLineChartDataSet,
                                        Self.Set.Styling: CTRangedLineStyle {
    internal func setupRangeLegends() {
        if dataSets.style.fillColour.colourType == .colour,
           let colour = dataSets.style.fillColour.colour
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(colour: colour),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .bar))
            
        } else if dataSets.style.fillColour.colourType == .gradientColour,
                  let colours = dataSets.style.fillColour.colours
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(colours: colours,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .bar))
            
        } else if dataSets.style.fillColour.colourType == .gradientStops,
                  let stops = dataSets.style.fillColour.stops
        {
            self.legends.append(LegendData(id         : UUID(),
                                           legend     : dataSets.legendFillTitle,
                                           colour     : ColourStyle(stops: stops,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                           strokeStyle: dataSets.style.strokeStyle,
                                           prioity    : 1,
                                           chartType  : .bar))
        }
    }
}

// MARK: - Accessibility
extension CTLineChartDataProtocol where Set: CTLineChartDataSet {
    public func getAccessibility() -> some View {
        ForEach(dataSets.dataPoints.indices, id: \.self) { point in
            
            AccessibilityRectangle(dataPointCount : self.dataSets.dataPoints.count,
                                   dataPointNo    : point)
                
                .foregroundColor(Color(.gray).opacity(0.000000001))
                .accessibilityLabel(Text("\(self.metadata.title)"))
                .accessibilityValue(self.dataSets.dataPoints[point].getCellAccessibilityValue(specifier: self.infoView.touchSpecifier))
        }
    }
}
