//
//  InfoBox.swift
//  
//
//  Created by Will Dale on 15/02/2021.
//

import SwiftUI

/**
 A view that displays information from `TouchOverlay`.
 */
internal struct InfoBox<T>: ViewModifier where T: CTChartData {
    
    @ObservedObject var chartData: T
    
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
            case .fixed:
                VStack {
                    fixed
                    content
                }
            case .header:
                EmptyView()
            }
        }
    }
    
    private var floating: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame : $boxFrame)
            .position(x: setBoxLocationation(touchLocation: chartData.infoView.touchLocation.x,
                                             boxFrame     : boxFrame,
                                             chartSize    : chartData.infoView.chartSize) )//,
                      //y: 35)
            .frame(height: 70)
            .zIndex(1)
    }

    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame : $boxFrame)
            .frame(height: 70)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
    
    
    /// Sets the point info box location while keeping it within the parent view.
    /// - Parameters:
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    private func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {

        var returnPoint : CGFloat = .zero

        if touchLocation < chartSize.minX + (boxFrame.width / 2) {
            returnPoint = chartSize.minX + (boxFrame.width / 2)
        } else if touchLocation > chartSize.maxX - (boxFrame.width / 2) {
            returnPoint = chartSize.maxX - (boxFrame.width / 2)
        } else {
            returnPoint = touchLocation
        }
        return returnPoint + chartData.infoView.yAxisLabelWidth
    }
}

extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to
     display touch overlay information.
     */
    public func infoBox<T: CTChartData>(chartData: T) -> some View {
        self.modifier(InfoBox(chartData: chartData))
    }
}
