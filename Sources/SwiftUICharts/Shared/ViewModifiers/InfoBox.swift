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
    
    @ObservedObject private var chartData: T
    
    internal init(chartData: T) {
        self.chartData = chartData
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
            .position(x: chartData.setBoxLocationation(touchLocation: chartData.infoView.touchLocation.x,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartData.infoView.chartSize) - 6, // -6 to compensate for `.padding(.horizontal, 6)`
                      y: 35)
            .frame(height: 70)
            .padding(.horizontal, 6)
            .zIndex(1)
    }
    
    private var fixed: some View {
        TouchOverlayBox(chartData: chartData,
                        boxFrame: $boxFrame)
            .frame(height: 70)
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
    public func infoBox<T: CTChartData>(chartData: T) -> some View {
        self.modifier(InfoBox(chartData: chartData))
    }
}
