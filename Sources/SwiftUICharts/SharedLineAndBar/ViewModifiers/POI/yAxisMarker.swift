//
//  yAxisMarker.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

// MARK: - API
extension View {
    public func yAxisMarker<ChartData: CTChartData & DataHelper, Label: View>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        value: Double,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        label: Label
    ) -> some View {
        self.modifier(
            YAxisMarker_HorizontalPosition(
                chartData: chartData,
                stateObject: stateObject,
                value: value,
                position: position,
                style: style,
                label: label
            )
        )
    }
    
    public func yAxisMarker<ChartData: CTChartData & DataHelper, Label: View>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        value: Double,
        position: AxisMarkerStyle.Horizontal,
        style: AxisMarkerStyle,
        label: () -> Label
    ) -> some View {
        self.modifier(
            YAxisMarker_HorizontalPosition(
                chartData: chartData,
                stateObject: stateObject,
                value: value,
                position: position,
                style: style,
                label: label()
            )
        )
    }
    
    public func yAxisMarker<ChartData: CTChartData & DataHelper, Label: View>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        value: Double,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        label: Label
    ) -> some View {
        self.modifier(
            YAxisMarker_VerticalPosition(
                chartData: chartData,
                stateObject: stateObject,
                value: value,
                position: position,
                style: style,
                label: label
            )
        )
    }
    
    public func yAxisMarker<ChartData: CTChartData & DataHelper, Label: View>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        value: Double,
        position: AxisMarkerStyle.Vertical,
        style: AxisMarkerStyle,
        label: () -> Label
    ) -> some View {
        self.modifier(
            YAxisMarker_VerticalPosition(
                chartData: chartData,
                stateObject: stateObject,
                value: value,
                position: position,
                style: style,
                label: label()
            )
        )
    }
}

// MARK: - Implementation
internal struct YAxisMarker_HorizontalPosition<ChartData: CTChartData & DataHelper, Label: View>: ViewModifier {
    
    internal var chartData: ChartData
    @ObservedObject internal var stateObject: ChartStateObject
    internal let value: Double
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
        stateObject.horizontalLinePosition(value: value, position: position, minValue: chartData.dataSetInfo.minValue, range: chartData.dataSetInfo.range)
    }
}

internal struct YAxisMarker_VerticalPosition<ChartData: CTChartData & DataHelper, Label: View>: ViewModifier {
    
    internal var chartData: ChartData
    @ObservedObject internal var stateObject: ChartStateObject
    internal let value: Double
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
        stateObject.verticalLinePosition(value: value, position: position, minValue: chartData.dataSetInfo.minValue, range: chartData.dataSetInfo.range)
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
