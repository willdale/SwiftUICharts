//
//  FloatingInfoBox.swift
//  
//
//  Created by Will Dale on 12/03/2021.
//

import SwiftUI

/**
 A view that displays information from `TouchOverlay`.
 */
internal struct FloatingInfoBox<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
    }
    
    @State private var boxFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 70)
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                ZStack {
                    floating
                    content
                }
            case .infoBox:
                content
            case .header:
                content
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .position(x: chartData.setBoxLocation(touchLocation: chartData.infoView.touchLocation.x,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartData.infoView.chartSize) - 6, // -6 to compensate for `.padding(.horizontal, 6)`
                      y: boxFrame.midY - 10)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
}

/**
 A view that displays information from `TouchOverlay`.
 */
internal struct HorizontalFloatingInfoBox<T>: ViewModifier where T: CTLineBarChartDataProtocol & isHorizontal {
    
    @ObservedObject private var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
    }
    
    @State private var boxFrame: CGRect = CGRect(x: 0, y: 0, width: 70, height: 70)
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                ZStack {
                    floating
                    content
                }
            case .infoBox:
                content
            case .header:
                content
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .position(x: chartData.infoView.chartSize.width,
                      y: chartData.setBoxLocation(touchLocation: chartData.infoView.touchLocation.y,
                boxFrame: boxFrame,
                chartSize: chartData.infoView.chartSize))
            .padding(.horizontal, 6)
            .zIndex(1)
    }
}

extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     Places the info box on top of the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func floatingInfoBox<T: CTLineBarChartDataProtocol>(chartData: T) -> some View {
        self.modifier(FloatingInfoBox(chartData: chartData))
    }
    
    /**
     A view that displays information from `TouchOverlay`.
     
     Places the info box on top of the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func floatingInfoBox<T: CTLineBarChartDataProtocol & isHorizontal>(chartData: T) -> some View {
        self.modifier(HorizontalFloatingInfoBox(chartData: chartData))
    }
}

