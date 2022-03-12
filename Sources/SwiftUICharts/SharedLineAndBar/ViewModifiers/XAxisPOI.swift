//
//  XAxisPOI.swift
//  
//
//  Created by Will Dale on 19/06/2021.
//

import SwiftUI

// MARK: - API
extension View {
    public func xAxisMarker<Label: View>(
        value: Int,
        total: Int,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        chartName: ChartName,
        label: Label
    ) -> some View {
        self.modifier(
            XAxisMarker_HorizontalPosition(
                value: value,
                total: total,
                position: position,
                style: style,
                chartName: chartName,
                label: label
            )
        )
    }
    
    public func xAxisMarker<Label: View>(
        value: Int,
        total: Int,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        chartName: ChartName,
        label: () -> Label
    ) -> some View {
        self.modifier(
            XAxisMarker_HorizontalPosition(
                value: value,
                total: total,
                position: position,
                style: style,
                chartName: chartName,
                label: label()
            )
        )
    }
    
    public func xAxisMarker<Label: View>(
        value: Int,
        total: Int,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        chartName: ChartName,
        label: Label
    ) -> some View {
        self.modifier(
            XAxisMarker_VerticalPosition(
                value: value,
                total: total,
                position: position,
                style: style,
                chartName: chartName,
                label: label
            )
        )
    }
    
    public func xAxisMarker<Label: View>(
        value: Int,
        total: Int,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        chartName: ChartName,
        label: () -> Label
    ) -> some View {
        self.modifier(
            XAxisMarker_VerticalPosition(
                value: value,
                total: total,
                position: position,
                style: style,
                chartName: chartName,
                label: label()
            )
        )
    }
}

// MARK: - Implementation
internal struct XAxisMarker_HorizontalPosition<Label: View>: ViewModifier {
    
    @EnvironmentObject var state: ChartStateObject
    
    internal let value: Int
    internal let total: Int
    internal let position: PoiStyle.HorizontalPosition
    internal let style: PoiStyle
    internal let chartName: ChartName
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
        if chartName.isBar {
            return state.horizontalLineIndexedBarPosition(value: value, count: total, position: position)
        } else {
            return state.horizontalLineIndexedPosition(value: value, count: total, position: position)
        }
    }
}

internal struct XAxisMarker_VerticalPosition<Label: View>: ViewModifier {
    
    @EnvironmentObject var state: ChartStateObject
    
    internal let value: Int
    internal let total: Int
    internal let position: PoiStyle.VerticalPosition
    internal let style: PoiStyle
    internal let chartName: ChartName
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
        if chartName.isBar {
            return state.verticalLineIndexedBarPosition(value: value, count: total, position: position)
        } else {
            return state.verticalLineIndexedPosition(value: value, count: total, position: position)
        }
    }
}
