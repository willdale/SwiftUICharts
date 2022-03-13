//
//  yAxisMarker.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

// MARK: - API
extension View {
    public func yAxisMarker<Label: View>(
        value: Double,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        dataSetInfo: DataSetInfo,
        label: Label
    ) -> some View {
        self.modifier(
            YAxisMarker_HorizontalPosition(
                value: value,
                position: position,
                style: style,
                dataSetInfo: dataSetInfo,
                label: label
            )
        )
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        dataSetInfo: DataSetInfo,
        label: () -> Label
    ) -> some View {
        self.modifier(
            YAxisMarker_HorizontalPosition(
                value: value,
                position: position,
                style: style,
                dataSetInfo: dataSetInfo,
                label: label()
            )
        )
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        dataSetInfo: DataSetInfo,
        label: Label
    ) -> some View {
        self.modifier(
            YAxisMarker_VerticalPosition(
                value: value,
                position: position,
                style: style,
                dataSetInfo: dataSetInfo,
                label: label
            )
        )
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        dataSetInfo: DataSetInfo,
        label: () -> Label
    ) -> some View {
        self.modifier(
            YAxisMarker_VerticalPosition(
                value: value,
                position: position,
                style: style,
                dataSetInfo: dataSetInfo,
                label: label()
            )
        )
    }
}

// MARK: - Implementation
internal struct YAxisMarker_HorizontalPosition<Label: View>: ViewModifier {
    
    @EnvironmentObject var state: ChartStateObject
    
    internal let value: Double
    internal let position: AxisMarkerStyle.Horizontal
    internal let style: AxisMarkerStyle
    internal let dataSetInfo: DataSetInfo
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
        state.horizontalLinePosition(value: value, position: position, dataSetInfo: dataSetInfo)
    }
}

internal struct YAxisMarker_VerticalPosition<Label: View>: ViewModifier {
    
    @EnvironmentObject var state: ChartStateObject
    
    internal let value: Double
    internal let position: AxisMarkerStyle.Vertical
    internal let style: AxisMarkerStyle
    internal let dataSetInfo: DataSetInfo
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
        state.verticalLinePosition(value: value, position: position, dataSetInfo: dataSetInfo)
    }
}

// MARK: - deprecated api
extension View {
    /**
     Horizontal line marking the average.
     
     Shows a marker line at the average of all the data points within
     the relevant data set(s).
     */
    @available(*, deprecated, message: "Please do this client side using \".yAxisPOI\"")
    public func averageLine(
        label: String,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        addToLegends: Bool = true
    ) -> some View {
        self.modifier(EmptyModifier())
    }

    /**
     Vertical line marking the average.
     
     Shows a marker line at the average of all the data points within
     the relevant data set(s).
     */
    @available(*, deprecated, message: "Please do this client side using \".yAxisPOI\"")
    public func averageLine(
        label: String,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        addToLegends: Bool = true
    ) -> some View {
        self.modifier(EmptyModifier())
    }
}
