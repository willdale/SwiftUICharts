//
//  XAxisPOI.swift
//  
//
//  Created by Will Dale on 19/06/2021.
//

import SwiftUI

/**
 Configurable Point of interest
 */
internal struct XAxisPOI<ChartData>: ViewModifier
where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol {
   
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let value: Int
    private let total: Int
    private let position: PoiPositionable
    private let style: PoiStyle
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        label: String,
        value: Int,
        total: Int,
        position: PoiPositionable,
        style: PoiStyle,
        addToLegends: Bool
    ) {
        self.chartData = chartData
        self.label = label
        self.value = value
        self.total = total
        self.position = position
        self.style = style
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            chartData.xAxisPOIMarker(value: value, total: total)
                .trim(to: startAnimation ? 1 : 0)
                .stroke(style.lineColour, style: style.strokeStyle)
            _X_AxisLabel(chartData: chartData, label: label, value: value, total: total, position: position, style: style)
            
            .accessibilityLabel(LocalizedStringKey("P-O-I-Marker"))
            .accessibilityValue(LocalizedStringKey(label))
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
        }
    }
}


// MARK: - Extension
extension View {
    /**
     Vertical line marking a custom value.
     
     Shows a marker line at a specified value.
     
     
     */
    public func xAxisPOI<ChartData>(
        chartData: ChartData,
        label: String,
        value: Int,
        total: Int,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View
    where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol
    {
        self.modifier(XAxisPOI(chartData: chartData,
                               label: label,
                               value: value,
                               total: total,
                               position: position,
                               style: style,
                               addToLegends: addToLegends))
    }
    
    public func xAxisPOI<ChartData>(
        chartData: ChartData,
        label: String,
        value: Int,
        total: Int,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View
    where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol & HorizontalChart
    {
        self.modifier(XAxisPOI(chartData: chartData,
                               label: label,
                               value: value,
                               total: total,
                               position: position,
                               style: style,
                               addToLegends: addToLegends))
    }
}


fileprivate struct _X_AxisLabel<ChartData>: View
where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let value: Int
    private let total: Int
    private let position: PoiPositionable
    private let style: PoiStyle
    
    internal init(
        chartData: ChartData,
        label: String,
        value: Int,
        total: Int,
        position: PoiPositionable,
        style: PoiStyle
    ) {
        self.chartData = chartData
        self.label = label
        self.value = value
        self.total = total
        self.position = position
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            Text(LocalizedStringKey(label))
                .font(style.font)
                .foregroundColor(style.textColour)
                .padding(4)
                .padding(.vertical, 4)
                .background(style.background)
                .modifier(_X_AxisLabel_Shape(position: position, style: style))
                .position(chartData.xAxisPOIMarkerPosition(value: value,
                                                           count: total,
                                                           position: position,
                                                           chartSize: geo.frame(in: .local)))
        }
    }
}

fileprivate struct _X_AxisLabel_Shape: ViewModifier {
    
    let position: PoiPositionable
    let style: PoiStyle
    
    func body(content: Content) -> some View {
        Group {
            switch position.type {
            case .horizontal:
                _X_AxisLabel_Shape_Horizontal(content: content,
                                              position: position as? PoiStyle.HorizontalPosition,
                                              style: style)
            case .vertical:
                _X_AxisLabel_Shape_Vertical(content: content,
                                            position: position as? PoiStyle.VerticalPosition,
                                            style: style)
            default:
                content
            }
        }
    }
}

fileprivate struct _X_AxisLabel_Shape_Horizontal<Content: View>: View {
    
    let content: Content
    let position: PoiStyle.HorizontalPosition?
    let style: PoiStyle
    
    var body: some View {
        Group {
            switch position {
            case .leading:
                content
                    .clipShape(LeadingLabelShape())
                    .overlay(LeadingLabelShape().stroke(style.lineColour))
            case .center:
                content
                    .clipShape(DiamondShape())
                    .overlay(DiamondShape().stroke(style.lineColour, style: style.strokeStyle))
            case .trailing:
                content
                    .clipShape(TrailingLabelShape())
                    .overlay(TrailingLabelShape().stroke(style.lineColour))
            default:
                content
            }
        }
    }
}


fileprivate struct _X_AxisLabel_Shape_Vertical<Content: View>: View {
    
    let content: Content
    let position: PoiStyle.VerticalPosition?
    let style: PoiStyle
    
    var body: some View {
        Group {
            switch position {
            case .top:
                content
                    .clipShape(TopLabelShape())
                    .overlay(TopLabelShape().stroke(style.lineColour))
            case .center:
                content
                    .clipShape(DiamondShape())
                    .overlay(DiamondShape().stroke(style.lineColour, style: style.strokeStyle))
            case .bottom:
                content
                    .clipShape(BottomLabelShape())
                    .overlay(BottomLabelShape().stroke(style.lineColour))
            default:
                content
            }
        }
    }
}
