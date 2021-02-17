//
//  TouchOverlay.swift
//  LineChart
//
//  Created by Will Dale on 29/12/2020.
//

import SwiftUI

#if !os(tvOS)
/**
 Detects input either from touch of pointer.
 
 Finds the nearest data point and displays the relevent information.
 
 */
internal struct TouchOverlay<T>: ViewModifier where T: ChartData {

    @ObservedObject var chartData: T
    
    private var markerType : MarkerType
    
    /// Current location of the touch input
    @State private var touchLocation    : CGPoint   = CGPoint(x: 0, y: 0)
    /// Frame information of the data point information box
    @State private var boxFrame         : CGRect    = CGRect(x: 0, y: 0, width: 0, height: 50)

    /// Detects input either from touch of pointer. Finds the nearest data point and displays the relevent information.
    /// - Parameters:
    ///   - chartData:
    ///   - specifier: Decimal precision for labels
    internal init(chartData         : T,
                  specifier         : String,
                  markerType        : MarkerType
    ) {
        self.chartData = chartData
        self.markerType = markerType
        self.chartData.infoView.touchSpecifier = specifier
    }
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
 
                GeometryReader { geo in
                    ZStack {
                        content
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { (value) in
                                        touchLocation = value.location
                                                                                
                                        chartData.infoView.isTouchCurrent   = true
                                        chartData.infoView.touchOverlayInfo = chartData.getDataPoint(touchLocation: touchLocation, chartSize: geo)
                                        
                                        chartData.infoView.positionX = setBoxLocationation(touchLocation: touchLocation, boxFrame: boxFrame, chartSize: geo).x
                                        
                                        chartData.infoView.frame = geo.frame(in: .local)
                                        
                                    }
                                    .onEnded { _ in
                                        chartData.infoView.isTouchCurrent   = false
                                        chartData.infoView.touchOverlayInfo = []
                                    }
                            )
                        /*
                         TODO: -------------------------------
                         Choose attachement style for markers
                         Add touch event function to protocol
                         */
                        if chartData.infoView.isTouchCurrent {
                            
                            switch chartData.chartType {
                            case (.line, .single):
                                Text("")
                                if let data = chartData as? LineChartData {
                                let position = data.getIndicatorLocation(rect: geo.frame(in: .global),
                                                                         dataSet: data.dataSets,
                                                                         touchLocation: touchLocation)

                                switch markerType  {
                                case .vertical:
                                    Vertical(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                case .rectangle:
                                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                        .fill(Color.clear)
                                        .frame(width: 100, height: geo.frame(in: .local).height)
                                        .position(x: position.x,
                                                  y: geo.frame(in: .local).midY)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                                .stroke(Color.primary, lineWidth: 2)
                                                .shadow(color: .primary, radius: 4, x: 0, y: 0)
                                                .frame(width: 50, height: geo.frame(in: .local).height)
                                                .position(x: position.x,
                                                          y: geo.frame(in: .local).midY)
                                        )
                                case .full:
                                    MarkerFull(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                case .bottomLeading:
                                    MarkerBottomLeading(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                case .bottomTrailing:
                                    MarkerBottomTrailing(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                case .topLeading:
                                    MarkerTopLeading(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                case .topTrailing:
                                    MarkerTopTrailing(position: position)
                                        .stroke(Color.primary, lineWidth: 2)
                                }

                                PosistionIndicator()
                                    .frame(width: 15, height: 15)
                                    .position(position)

                                }
                                
                            case (.line, .multi):

                                if let data = chartData as? MultiLineChartData {

                                    ForEach(data.dataSets.dataSets, id: \.self) { dataSet in
                                        let position = data.getIndicatorLocation(rect: geo.frame(in: .global),
                                                                                 dataSet: dataSet,
                                                                                 touchLocation: touchLocation)

                                        switch markerType  {
                                        case .vertical:
                                            Vertical(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .rectangle:
                                            RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                                .fill(Color.clear)
                                                .frame(width: 100, height: geo.frame(in: .local).height)
                                                .position(x: position.x,
                                                          y: geo.frame(in: .local).midY)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                                        .stroke(Color.primary, lineWidth: 2)
                                                        .shadow(color: .primary, radius: 4, x: 0, y: 0)
                                                        .frame(width: 50, height: geo.frame(in: .local).height)
                                                        .position(x: position.x,
                                                                  y: geo.frame(in: .local).midY)
                                                )
                                        case .full:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomLeading:
                                            MarkerBottomLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomTrailing:
                                            MarkerBottomTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topLeading:
                                            MarkerTopLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topTrailing:
                                            MarkerTopTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        }


                                        PosistionIndicator()
                                            .frame(width: 15, height: 15)
                                            .position(position)
                                    }
                                }
                                
                            case (.bar, .single):

                                if let data = chartData as? BarChartData {
                                    
                                    let positions = data.getPointLocation(touchLocation: touchLocation,
                                                                          chartSize: geo)
                                    ForEach(positions, id: \.self) { position in
                                        
                                        switch markerType  {
                                        case .vertical:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .rectangle:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .full:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomLeading:
                                            MarkerBottomLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomTrailing:
                                            MarkerBottomTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topLeading:
                                            MarkerTopLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topTrailing:
                                            MarkerTopTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        }
                                    }
                                    
                                }
                            case (.bar, .multi):
                                if let data = chartData as? GroupedBarChartData {

                                    let positions = data.getPointLocation(touchLocation: touchLocation,
                                                                          chartSize: geo)
                                    ForEach(positions, id: \.self) { position in
                                        
                                        switch markerType  {
                                        case .vertical:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .rectangle:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .full:
                                            MarkerFull(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomLeading:
                                            MarkerBottomLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .bottomTrailing:
                                            MarkerBottomTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topLeading:
                                            MarkerTopLeading(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        case .topTrailing:
                                            MarkerTopTrailing(position: position)
                                                .stroke(Color.primary, lineWidth: 2)
                                        }
                                    }
                                }
                                
                            case (.pie, .single):
                                Text("")
                            case (.pie, .multi):
                                Text("")
                            }
                        }
                    }
                }
            } else { content }
        }
    }

    /// Sets the point info box location while keeping it within the parent view.
    /// - Parameters:
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    internal func setBoxLocationation(touchLocation: CGPoint, boxFrame: CGRect, chartSize: GeometryProxy) -> CGPoint {

        var returnPoint : CGPoint = .zero

        if touchLocation.x < chartSize.frame(in: .local).minX + (boxFrame.width / 2) {
            returnPoint.x = chartSize.frame(in: .local).minX + (boxFrame.width / 2)
        } else if touchLocation.x > chartSize.frame(in: .local).maxX - (boxFrame.width / 2) {
            returnPoint.x = chartSize.frame(in: .local).maxX - (boxFrame.width / 2)
        } else {
            returnPoint.x = touchLocation.x
        }
        return returnPoint
    }
}
#endif

extension View {
    #if !os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Requires:
     If  LineChartStyle --> infoBoxPlacement is set to .header
     then `.headerBox` is required.
     
     - Attention:
     Unavailable in tvOS
     
     - Parameters:
        - chartData: Chart data model.
        - specifier: Decimal precision for labels.
     - Returns: A  new view containing the chart with a touch overlay.
     
     - Tag: TouchOverlay
     */
    public func touchOverlay<T: ChartData>(chartData: T,
                                           specifier: String = "%.0f",
                                           markerType: MarkerType = .vertical
    ) -> some View {
        self.modifier(TouchOverlay(chartData: chartData,
                                   specifier: specifier,
                                   markerType: markerType))
    }
    #elseif os(tvOS)
    /**
     Adds touch interaction with the chart.
     
     - Attention:
     Unavailable in tvOS
     */
    public func touchOverlay<T: ChartData>(chartData: T,
                                           specifier: String = "%.0f",
                                           markerType: MarkerType = .fullWidth
    ) -> some View {
        self.modifier(EmptyModifier())
    }
    #endif
}

struct PosistionIndicator: View {
        
    var body: some View {
        Circle()
            .strokeBorder(Color.red, lineWidth: 3)
    }
}
