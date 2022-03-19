//
//  InfoBox.swift
//  
//
//  Created by Will Dale on 15/02/2021.
//

import SwiftUI

// MARK: Vertical
/**
 A view that displays information from `TouchOverlay`.
 */
internal struct InfoBox<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let height: CGFloat
    
    internal init(
        chartData: T,
        height: CGFloat
    ) {
        self.chartData = chartData
        self.height = height
    }
    
    @State private var boxFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 70)
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                content
            case .infoBox(let isStatic):
                switch isStatic {
                case true:
                    VStack {
                        fixed
                        content
                    }
                case false:
                    VStack {
                        floating
                        content
                    }
                }
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
                      y: height / 2)
            .frame(height: height)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .frame(height: height)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
}

// MARK: Horizontal
/**
 A view that displays information from `TouchOverlay`.
 */
internal struct HorizontalInfoBox<T>: ViewModifier where T: CTLineBarChartDataProtocol & isHorizontal {
    
    @ObservedObject private var chartData: T
    private let width: CGFloat
    
    internal init(
        chartData: T,
        width: CGFloat
    ) {
        self.chartData = chartData
        self.width = width
    }
    
    @State private var boxFrame: CGRect = CGRect(x: 0, y: 0, width: 70, height: 0)
    
    internal func body(content: Content) -> some View {
        Group {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                content
            case .infoBox(let isStatic):
                switch isStatic {
                case true:
                    HStack {
                        content
                        fixed
                    }
                case false:
                    HStack {
                        content
                        floating
                    }
                }
            case .header:
                content
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .position(x: 35,
                      y: chartData.setBoxLocation(touchLocation: chartData.infoView.touchLocation.y,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartData.infoView.chartSize))
            .frame(width: width)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .frame(width: width)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
}
extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func infoBox<T: CTLineBarChartDataProtocol>(
        chartData: T,
        height: CGFloat = 70
    ) -> some View {
        self.modifier(InfoBox(chartData: chartData, height: height))
    }

    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameters:
        - chartData: Chart data model.
        - width: Width of the view.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func infoBox<T: CTLineBarChartDataProtocol & isHorizontal>(
        chartData: T,
        width: CGFloat = 70
    ) -> some View {
        self.modifier(HorizontalInfoBox(chartData: chartData, width: width))
    }
}
