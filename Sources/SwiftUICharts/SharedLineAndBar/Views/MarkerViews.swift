//
//  MarkerViews.swift
//  
//
//  Created by Will Dale on 12/09/2021.
//

import SwiftUI


internal struct MarkerView {
    
    internal static func bar(
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
                MarkerBottomLeading(position: markerData.location)
                    .stroke(colour, style: style)
            case .bottomTrailing(let colour, let style):
                MarkerBottomTrailing(position: markerData.location)
                    .stroke(colour, style: style)
            case .topLeading(let colour, let style):
                MarkerTopLeading(position: markerData.location)
                    .stroke(colour, style: style)
            case .topTrailing(let colour, let style):
                MarkerTopTrailing(position: markerData.location)
                    .stroke(colour, style: style)
            }
        }
    }
    
    internal static func line(
        lineMarker: LineMarkerType,
        markerData: LineMarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint,
        dataPoints: [Double],
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        minValue: Double,
        range: Double,
        ignoreZero: Bool
    ) -> some View {
        
        let indicatorLocation = PositionIndicator.getIndicatorLocation(rect: chartSize,
                                                                       dataPoints: dataPoints,
                                                                       touchLocation: touchLocation,
                                                                       lineType: lineType,
                                                                       lineSpacing: lineSpacing,
                                                                       minValue: minValue,
                                                                       range: range,
                                                                       ignoreZero: ignoreZero)
        
        return Group {
            switch lineMarker {
            case .none:
                EmptyView()
            case .indicator(let style):
                
                PosistionIndicator(fillColour: style.fillColour,
                                   lineColour: style.lineColour,
                                   lineWidth: style.lineWidth)
                    .frame(width: style.size, height: style.size)
                    .position(indicatorLocation)
                
            case .vertical(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    Vertical(position: indicatorLocation).stroke(colour, style: style)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    Vertical(position: markerData.location).stroke(colour, style: style)
                }
                
            case .full(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerFull(position: indicatorLocation).stroke(colour, style: style)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerFull(position: markerData.location).stroke(colour, style: style)
                }
                
            case .bottomLeading(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerBottomLeading(position: indicatorLocation).stroke(Color.primary, lineWidth: 2)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomLeading(position: markerData.location).stroke(colour, style: style)
                }
                
            case .bottomTrailing(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerBottomTrailing(position: indicatorLocation).stroke(colour, style: style)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomTrailing(position: markerData.location).stroke(colour, style: style)
                }
                
            case .topLeading(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerTopLeading(position: indicatorLocation).stroke(colour, style: style)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerTopLeading(position: markerData.location).stroke(colour, style: style)
                }
                
            case .topTrailing(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerTopTrailing(position: indicatorLocation).stroke(colour, style: style)
                    IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerTopTrailing(position: markerData.location).stroke(colour, style: style)
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
