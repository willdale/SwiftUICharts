//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

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
        self.modifier(YAxisMarker_HorizontalPosition(value: value,
                                                     position: position,
                                                     style: style,
                                                     dataSetInfo: dataSetInfo,
                                                     label: label))
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        dataSetInfo: DataSetInfo,
        label: () -> Label
    ) -> some View {
        self.modifier(YAxisMarker_HorizontalPosition(value: value,
                                                     position: position,
                                                     style: style,
                                                     dataSetInfo: dataSetInfo,
                                                     label: label()))
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        dataSetInfo: DataSetInfo,
        label: Label
    ) -> some View {
        self.modifier(YAxisMarker_VerticalPosition(value: value,
                                                   position: position,
                                                   style: style,
                                                   dataSetInfo: dataSetInfo,
                                                   label: label))
    }
    
    public func yAxisMarker<Label: View>(
        value: Double,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        dataSetInfo: DataSetInfo,
        label: () -> Label
    ) -> some View {
        self.modifier(YAxisMarker_VerticalPosition(value: value,
                                                   position: position,
                                                   style: style,
                                                   dataSetInfo: dataSetInfo,
                                                   label: label()))
    }
}

internal struct YAxisMarker_HorizontalPosition<Label: View>: ViewModifier {
    
    internal let value: Double
    internal let position: PoiStyle.HorizontalPosition
    internal let style: PoiStyle
    internal let dataSetInfo: DataSetInfo
    internal let label: Label
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            _AxisLabel_HorizontalPosition(value: value, position: position, style: style, dataSetInfo: dataSetInfo, label: label)
        }
    }
}

internal struct YAxisMarker_VerticalPosition<Label: View>: ViewModifier {
    
    internal let value: Double
    internal let position: PoiStyle.VerticalPosition
    internal let style: PoiStyle
    internal let dataSetInfo: DataSetInfo
    internal let label: Label
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            _AxisLabel_VerticalPosition(value: value, position: position, style: style, dataSetInfo: dataSetInfo, label: label)
        }
    }
}

fileprivate struct _AxisLabel_HorizontalPosition<Label: View>: View {
    
    @EnvironmentObject var state: ChartStateObject

    internal let value: Double
    internal let position: PoiStyle.HorizontalPosition
    internal let style: PoiStyle
    internal let dataSetInfo: DataSetInfo
    internal let label: Label
    
    internal var body: some View {
       label
            .position(state.verticalLineMarkerPosition(value: value,
                                                 position: position,
                                                 chartSize: state.chartSize.size,
                                                 dataSetInfo: dataSetInfo))
        
        AxisHorizontalMarker(yPosition: state.verticalLineMarkerPosition(value: value,
                                                                         position: position,
                                                                         chartSize: state.chartSize.size,
                                                                         dataSetInfo: dataSetInfo).y)
            .stroke(style.colour, style: style.strokeStyle)
    }
}

fileprivate struct _AxisLabel_VerticalPosition<Label: View>: View {
    
    @EnvironmentObject var state: ChartStateObject

    internal let value: Double
    internal let position: PoiStyle.VerticalPosition
    internal let style: PoiStyle
    internal let dataSetInfo: DataSetInfo
    internal let label: Label
    
    internal var body: some View {
       label
            .position(state.horizontalBarMarkerPosition(value: value, position: position, chartSize: state.chartSize.size, dataSetInfo: dataSetInfo))
        
        AxisVerticalMarker(yPosition: state.horizontalBarMarkerPosition(value: value, position: position, chartSize: state.chartSize.size, dataSetInfo: dataSetInfo).x)
            .stroke(style.colour, style: style.strokeStyle)
    }
}


import ChartMath

// MARK: - Position
//
//
//
// MARK: Vertical Charts
extension ChartStateObject {
    public func verticalLineMarkerPosition(value: Double, position: PoiStyle.HorizontalPosition, chartSize: CGSize, dataSetInfo: DataSetInfo) -> CGPoint {
        switch position {
        case .leading:
            return CGPoint(x: -(leadingInset / 2),
                           y: plotPointY(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: plotPointY(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + (trailingInset / 2),
                           y: plotPointY(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
        }
    }
}
/*
     // MARK: Line Charts
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: lineXAxisPOIMarkerX(value, count, chartSize.width),
                           y:  chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
*/

// MARK: Vertical Bar Charts
extension ChartStateObject {
//    public func veriticalBarMarkerPosition(value: Double, position: PoiStyle.HorizontalPosition, chartSize: CGSize, dataSetInfo: DataSetInfo) -> CGPoint {
//        switch position {
//        case .leading:
//            return CGPoint(x: -(leadingInset / 2),
//                           y: barYAxisPOIMarkerX(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
//        case .center:
//            return CGPoint(x: chartSize.width / 2,
//                           y: barYAxisPOIMarkerX(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
//        case .trailing:
//            return CGPoint(x: chartSize.width + (trailingInset / 2),
//                           y: barYAxisPOIMarkerX(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.height))
//        }
//    }
}

/*
    // MARK: Vertical Bar Charts
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 10.0
        switch position as? PoiStyle.VerticalPosition {
        case .top:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding)
        case .center:
            // (chartSize.width / CGFloat(count)) * CGFloat(value) + ((chartSize.width / CGFloat(count)) / 2)
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: barXAxisPOIMarkerX(value, count, chartSize.width),
                           y: chartSize.height + ((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) + padding)
        default:
            return .zero
        }
    }
*/

// MARK: Horizontal Bar Charts
extension ChartStateObject {
    public func horizontalBarMarkerPosition(value: Double, position: PoiStyle.VerticalPosition, chartSize: CGSize, dataSetInfo: DataSetInfo) -> CGPoint {
        switch position {
        case .top:
            return CGPoint(x: horizontalBarYPosition(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.width),
                           y: -(topInset / 2))
        case .center:
            return CGPoint(x: horizontalBarYPosition(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.width),
                           y: chartSize.height / 2)
        case .bottom:
            return CGPoint(x: horizontalBarYPosition(value, dataSetInfo.minValue, dataSetInfo.range, chartSize.width),
                           y: chartSize.height + topInset / 2)
        }
    }
}
/*
     // MARK: Horizontal Bar Charts
    public func xAxisPOIMarkerPosition(value: Int, count: Int, position: PoiPositionable, chartSize: CGRect) -> CGPoint {
        let padding: CGFloat = 8.0
        switch position as? PoiStyle.HorizontalPosition {
        case .leading:
            return CGPoint(x: -((xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2) - padding,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .center:
            return CGPoint(x: chartSize.width / 2,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        case .trailing:
            return CGPoint(x: chartSize.width + ((xAxisViewData.xAxisLabelWidths.max() ?? 0) / 2) + padding,
                           y: horizontalBarXAxisPOIMarkerY(value, count, chartSize.height))
        default:
            return .zero
        }
    }
*/

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
