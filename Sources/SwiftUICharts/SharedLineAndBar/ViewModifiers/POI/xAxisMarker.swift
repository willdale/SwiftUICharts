//
//  xAxisMarker.swift
//  
//
//  Created by Will Dale on 19/06/2021.
//

import SwiftUI

// MARK: - API
extension View {
    public func xAxisMarker<ChartData: CTChartData, Label: View>(
        chartData: ChartData,
        value: Int,
        total: Int,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        label: Label
    ) -> some View {
        self.modifier(
            XAxisMarker_HorizontalPosition(
                chartData: chartData,
                stateObject: chartData.stateObject,
                value: value,
                total: total,
                position: position,
                style: style,
                label: label
            )
        )
    }
    
    public func xAxisMarker<ChartData: CTChartData, Label: View>(
        chartData: ChartData,
        value: Int,
        total: Int,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        label: () -> Label
    ) -> some View {
        self.modifier(
            XAxisMarker_HorizontalPosition(
                chartData: chartData,
                stateObject: chartData.stateObject,
                value: value,
                total: total,
                position: position,
                style: style,
                label: label()
            )
        )
    }
    
    public func xAxisMarker<ChartData: CTChartData, Label: View>(
        chartData: ChartData,
        value: Int,
        total: Int,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        label: Label
    ) -> some View {
        self.modifier(
            XAxisMarker_VerticalPosition(
                chartData: chartData,
                stateObject: chartData.stateObject,
                value: value,
                total: total,
                position: position,
                style: style,
                label: label
            )
        )
    }
    
    public func xAxisMarker<ChartData: CTChartData, Label: View>(
        chartData: ChartData,
        value: Int,
        total: Int,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        label: () -> Label
    ) -> some View {
        self.modifier(
            XAxisMarker_VerticalPosition(
                chartData: chartData,
                stateObject: chartData.stateObject,
                value: value,
                total: total,
                position: position,
                style: style,
                label: label()
            )
        )
    }
}

// MARK: - Implementation
internal struct XAxisMarker_HorizontalPosition<ChartData: CTChartData, Label: View>: ViewModifier {
    
    internal var chartData: ChartData
    @ObservedObject internal var stateObject: ChartStateObject
    internal let value: Int
    internal let total: Int
    internal let position: AxisMarkerStyle.Horizontal
    internal let style: AxisMarkerStyle
    internal let label: Label
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            label.position(placement)
            AxisHorizontalMarker(yPosition: placement.y)
                .stroke(style.colour, style: style.strokeStyle)
        }
    }
    
    var placement: CGPoint {
        if chartData.chartName.isBar {
            return stateObject.horizontalLineIndexedBarPosition(value: value, count: total, position: position)
        } else {
            return stateObject.horizontalLineIndexedPosition(value: value, count: total, position: position)
        }
    }
}

internal struct XAxisMarker_VerticalPosition<ChartData: CTChartData, Label: View>: ViewModifier {
    
    internal var chartData: ChartData
    @ObservedObject internal var stateObject: ChartStateObject
    internal let value: Int
    internal let total: Int
    internal let position: AxisMarkerStyle.Vertical
    internal let style: AxisMarkerStyle
    internal let label: Label
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            label.position(placement)
            AxisVerticalMarker(yPosition: placement.x)
                .stroke(style.colour, style: style.strokeStyle)
        }
    }
    
    var placement: CGPoint {
        if chartData.chartName.isBar {
            return stateObject.verticalLineIndexedBarPosition(value: value, count: total, position: position)
        } else {
            return stateObject.verticalLineIndexedPosition(value: value, count: total, position: position)
        }
    }
}
