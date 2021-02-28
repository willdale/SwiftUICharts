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
    
    @State private var boxFrame   : CGRect    = CGRect(x: 0, y: 0, width: 0, height: 50)
    
    internal func body(content: Content) -> some View {
        VStack {
            switch chartData.chartStyle.infoBoxPlacement {
            case .floating:
                floating
            case .fixed:
                fixed
            case .header:
                EmptyView()
            }
            content
        }
    }
    
    var floating: some View {
        TouchOverlayBox(isTouchCurrent   : chartData.infoView.isTouchCurrent,
                        selectedPoints   : chartData.infoView.touchOverlayInfo,
                        specifier        : chartData.infoView.touchSpecifier,
                        unit             : chartData.infoView.touchUnit,
                        valueColour      : chartData.chartStyle.infoBoxValueColour,
                        descriptionColour: chartData.chartStyle.infoBoxDescriptionColour,
                        boxFrame         : $boxFrame)
            .position(x: setBoxLocationation(touchLocation: chartData.infoView.touchLocation.x,
                                             boxFrame     : boxFrame,
                                             chartSize    : chartData.infoView.chartSize),
                      y: 15)
            .frame(height: 40)
    }

    
    var fixed: some View {
        
        TouchOverlayBox(isTouchCurrent   : chartData.infoView.isTouchCurrent,
                        selectedPoints   : chartData.infoView.touchOverlayInfo,
                        specifier        : chartData.infoView.touchSpecifier,
                        unit             : chartData.infoView.touchUnit,
                        valueColour      : chartData.chartStyle.infoBoxValueColour,
                        descriptionColour: chartData.chartStyle.infoBoxDescriptionColour,
                        boxFrame         : $boxFrame)
        .frame(height: 40)
        .padding(.horizontal, 6)
        
    }
    
    
    /// Sets the point info box location while keeping it within the parent view.
    /// - Parameters:
    ///   - boxFrame: The size of the point info box.
    ///   - chartSize: The size of the chart view as the parent view.
    internal func setBoxLocationation(touchLocation: CGFloat, boxFrame: CGRect, chartSize: CGRect) -> CGFloat {

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
