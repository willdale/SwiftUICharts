//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import ChartMath
import SwiftUI

public struct PoiStyle {
    public var colour: Color
    public var strokeStyle: StrokeStyle
    
    public enum HorizontalPosition {
        case leading
        case trailing
        case center
    }
    
    public enum VerticalPosition {
        case top
        case bottom
        case center
    }
}

extension PoiStyle {
    public static let amber = PoiStyle(colour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                       strokeStyle: StrokeStyle(lineWidth: 1, dash: [5,10]))
}

// MARK: - API
extension View {
    public func yAxisMarker<Label: View>(
        value: Double,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
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
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
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
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
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
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
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
    internal let position: PoiStyle.HorizontalPosition
    internal let style: PoiStyle
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
    internal let position: PoiStyle.VerticalPosition
    internal let style: PoiStyle
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
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
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
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View {
        self.modifier(EmptyModifier())
    }
}
