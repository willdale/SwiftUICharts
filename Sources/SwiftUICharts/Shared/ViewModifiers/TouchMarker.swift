//
//  TouchMarker.swift
//  
//
//  Created by Will Dale on 03/04/2022.
//

import SwiftUI

extension View {
    public func touchMarker<ChartData, Icon: View>(
        chartData: ChartData,
        indicator: Icon
    ) -> some View where ChartData: CTChartData {
        self.modifier(TouchMarker(chartData: chartData, indicator: indicator))
    }
    
    public func touchMarker<ChartData, Icon: View>(
        chartData: ChartData,
        indicator: () -> Icon
    ) -> some View where ChartData: CTChartData {
        self.modifier(TouchMarker(chartData: chartData, indicator: indicator()))
    }
    
    public func touchMarker<ChartData>(
        chartData: ChartData,
        indicator: Dot
    ) -> some View where ChartData: CTChartData {
        Group {
            switch indicator {
            case .none:
                self.modifier(TouchMarker(chartData: chartData,
                                          indicator: EmptyView()))
            case .style(let style):
                self.modifier(TouchMarker(chartData: chartData,
                                          indicator: PosistionIndicator(
                                            fillColour: style.fillColour,
                                            lineColour: style.lineColour,
                                            lineWidth: style.lineWidth
                                          ).frame(width: style.size, height: style.size)))
            }
        }
    }
}

public struct TouchMarker<ChartData, Icon: View>: ViewModifier where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var touchObject: ChartTouchObject
    
    let indicator: Icon
    
    public init(
        chartData: ChartData,
        indicator: Icon
    ) {
        self.chartData = chartData
        self.touchObject = chartData.touchObject
        self.indicator = indicator
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if touchObject.isTouch {
                _MarkerData(markerData: chartData.markerData, indicator: indicator, chartSize: chartData.stateObject.chartSize, touchLocation: touchObject.touchLocation)
            }
        }
    }
    
    enum Indicator {
        case none
        case dot
    }
}


fileprivate struct _MarkerData<Icon: View>: View {

    private let markerData: MarkerData
    private let indicator: Icon
    private let chartSize: CGRect
    private let touchLocation: CGPoint
    
    internal init(
        markerData: MarkerData, 
        indicator: Icon, 
        chartSize: CGRect, 
        touchLocation: CGPoint
    ) {
        self.markerData = markerData
        self.indicator = indicator
        self.chartSize = chartSize
        self.touchLocation = touchLocation
    }
    
    fileprivate var body: some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                    line(lineMarker: marker.markerType,
                         indicator: indicator,
                         markerData: marker,
                         chartSize: chartSize,
                         touchLocation: touchLocation,
                         dataPoints: marker.dataPoints,
                         lineType: marker.lineType,
                         lineSpacing: marker.lineSpacing,
                         minValue: marker.minValue,
                         range: marker.range)
            }
        }
    }
    
    private func bar(
        barMarker: BarMarkerType,
        markerData: BarMarkerData
    ) -> some View {
        Group {
            switch barMarker {
            case .none:
                EmptyView()
            case .vertical(let colour, let style):
                MarkerFull(position: markerData.location)
                    .stroke(colour, style: style)
            case .full(let colour, let style):
                MarkerFull(position: markerData.location)
                    .stroke(colour, style: style)
            case .bottomLeading(let colour, let style):
                MarkerBottomLeading(position: markerData.location, lineWidth: style.lineWidth)
                    .stroke(colour, style: style)
            case .bottomTrailing(let colour, let style):
                MarkerBottomTrailing(position: markerData.location, lineWidth: style.lineWidth)
                    .stroke(colour, style: style)
            case .topLeading(let colour, let style):
                MarkerTopLeading(position: markerData.location, lineWidth: style.lineWidth)
                    .stroke(colour, style: style)
            case .topTrailing(let colour, let style):
                MarkerTopTrailing(position: markerData.location, lineWidth: style.lineWidth)
                    .stroke(colour, style: style)
            }
        }
    }
    
    private func line<Icon: View>(
        lineMarker: LineMarkerType,
        indicator: Icon,
        markerData: LineMarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint,
        dataPoints: [LineChartDataPoint],
        lineType: LineType,
        lineSpacing: SpacingType,
        minValue: Double,
        range: Double
    ) -> some View {
        let indicatorLocation = PositionIndicator.getIndicatorLocation(rect: chartSize,
                                                                       dataPoints: dataPoints,
                                                                       touchLocation: touchLocation,
                                                                       lineType: lineType,
                                                                       lineSpacing: lineSpacing,
                                                                       minValue: minValue,
                                                                       range: range)
        return Group {
            switch lineMarker {
            case .none:
                EmptyView()
            case .indicator:
                indicator
                    .position(indicatorLocation)
                
            case let .vertical(attach, colour, style):
                
                switch attach {
                case .line:
                    Vertical(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    Vertical(position: markerData.location).stroke(colour, style: style)
                }
                
            case let .full(attach, colour, style):
                
                switch attach {
                case .line:
                    MarkerFull(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerFull(position: markerData.location).stroke(colour, style: style)
                }
                
            case let .bottomLeading(attach, colour, style):
                
                switch attach {
                case .line:
                    MarkerBottomLeading(position: indicatorLocation, lineWidth: style.lineWidth)
                        .stroke(Color.primary, lineWidth: 2)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomLeading(position: markerData.location, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                }
                
            case let .bottomTrailing(attach, colour, style):
                
                switch attach {
                case .line:
                    MarkerBottomTrailing(position: indicatorLocation, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomTrailing(position: markerData.location, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                }
                
            case let .topLeading(attach, colour, style):
                
                switch attach {
                case .line:
                    MarkerTopLeading(position: indicatorLocation, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerTopLeading(position: markerData.location, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                }
                
            case let .topTrailing(attach, colour, style):
                
                switch attach {
                case .line:
                    MarkerTopTrailing(position: indicatorLocation, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerTopTrailing(position: markerData.location, lineWidth: style.lineWidth)
                        .stroke(colour, style: style)
                }
            }
        }
    }
}

 /**
  Sub view for laying out and styling the indicator dot.
  */
fileprivate struct _IndicatorSwitch<Icon: View>: View {
     
     private let indicator: Icon
     private let location: CGPoint
     
    fileprivate init(indicator: Icon, location: CGPoint) {
         self.indicator = indicator
         self.location = location
     }
     
    fileprivate var body: some View {
        indicator
            .position(location)
     }
 }

internal struct PosistionIndicator: View {
    
    private let fillColour: Color
    private let lineColour: Color
    private let lineWidth: CGFloat
    
    internal init(
        fillColour: Color = Color.primary,
        lineColour: Color = Color.blue,
        lineWidth: CGFloat = 3
    ) {
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth = lineWidth
    }
    
    internal var body: some View {
        ZStack {
            Circle()
                .foregroundColor(lineColour)
            Circle()
                .foregroundColor(fillColour)
                .padding(EdgeInsets(top: lineWidth, leading: lineWidth, bottom: lineWidth, trailing: lineWidth))
        }
    }
}

/**
 Whether or not to show a dot on the line
 
 ```
 case none // No Dot
 case style(_ style: DotStyle) // Adds a dot the line at point of touch.
 ```
 */
public enum Dot: Hashable {
    /// No Dot
    case none
    /// Adds a dot the line at point of touch.
    case style(_ style: DotStyle)
}

/**
 Styling of the dot that follows the line on touch events.
 */
public struct DotStyle: Hashable {
    
    let size: CGFloat
    let fillColour: Color
    let lineColour: Color
    let lineWidth: CGFloat
    
    /// Sets the style of the Posistion Indicator
    /// - Parameters:
    ///   - size: Size of the Indicator.
    ///   - fillColour: Fill colour.
    ///   - lineColour: Border colour.
    ///   - lineWidth: Border width.
    public init(
        size: CGFloat = 15,
        fillColour: Color = Color.primary,
        lineColour: Color = Color.blue,
        lineWidth: CGFloat = 3
    ) {
        self.size = size
        self.fillColour = fillColour
        self.lineColour = lineColour
        self.lineWidth = lineWidth
    }
}
