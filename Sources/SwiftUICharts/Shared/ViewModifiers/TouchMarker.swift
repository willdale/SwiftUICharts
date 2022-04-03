//
//  TouchMarker.swift
//  
//
//  Created by Will Dale on 03/04/2022.
//

import SwiftUI

extension View {
    public func touchMarker<ChartData>(chartData: ChartData) -> some View where ChartData: CTChartData {
        self.modifier(TouchMarker(chartData: chartData))
    }
}

public struct TouchMarker<ChartData>: ViewModifier where ChartData: CTChartData {
    
    @EnvironmentObject var stateObject: ChartStateObject
    @ObservedObject private var chartData: ChartData
    
    public init(
        chartData: ChartData
    ) {
        self.chartData = chartData
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            if stateObject.isTouch {
                _MarkerData(markerData: chartData.markerData, chartSize: stateObject.chartSize, touchLocation: stateObject.touchLocation)
            }
        }
    }
}


fileprivate struct _MarkerData: View {
    
    fileprivate let markerData: MarkerData
    fileprivate let chartSize: CGRect
    fileprivate let touchLocation: CGPoint
    
    fileprivate var body: some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                line(lineMarker: marker.markerType,
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
    
    private func line(
        lineMarker: LineMarkerType,
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
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    Vertical(position: markerData.location).stroke(colour, style: style)
                }
                
            case .full(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerFull(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerFull(position: markerData.location).stroke(colour, style: style)
                }
                
            case .bottomLeading(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerBottomLeading(position: indicatorLocation).stroke(Color.primary, lineWidth: 2)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomLeading(position: markerData.location).stroke(colour, style: style)
                }
                
            case .bottomTrailing(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerBottomTrailing(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerBottomTrailing(position: markerData.location).stroke(colour, style: style)
                }
                
            case .topLeading(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerTopLeading(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
                case .point:
                    MarkerTopLeading(position: markerData.location).stroke(colour, style: style)
                }
                
            case .topTrailing(attachment: let attach, let colour, let style):
                
                switch attach {
                case .line(dot: let indicator):
                    MarkerTopTrailing(position: indicatorLocation).stroke(colour, style: style)
                    _IndicatorSwitch(indicator: indicator, location: indicatorLocation)
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
fileprivate struct _IndicatorSwitch: View {
     
     private let indicator: Dot
     private let location: CGPoint
     
    fileprivate init(indicator: Dot, location: CGPoint) {
         self.indicator = indicator
         self.location = location
     }
     
    fileprivate var body: some View {
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
