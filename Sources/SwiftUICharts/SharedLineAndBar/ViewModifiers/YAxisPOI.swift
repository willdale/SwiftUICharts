//
//  YAxisPOI.swift
//  LineChart
//
//  Created by Will Dale on 31/12/2020.
//

import SwiftUI

public protocol PoiPositionable {
    var padding: CGFloat { get }
}

extension PoiPositionable {
    internal var type: _POIPositionType {
        switch self {
        case is PoiStyle.HorizontalPosition:
            return .horizontal
        case is PoiStyle.VerticalPosition:
            return .vertical
        default:
            return .none
        }
    }
}

internal enum _POIPositionType {
    case none
    case horizontal
    case vertical
}

public struct PoiStyle {
    public var lineColour: Color
    public var strokeStyle: StrokeStyle
    public var font: Font
    public var textColour: Color
    public var background: Color
    public var addToLegends: Bool
    
    public enum HorizontalPosition: PoiPositionable {
        case none
        case leading
        case trailing
        case center
        
        public var padding: CGFloat {
            switch self {
            case .none:
                return 0
            case .leading, .trailing:
                return 8
            case .center:
                return 16
            }
        }
    }
    
    public enum VerticalPosition: PoiPositionable {
        case none
        case top
        case bottom
        case center
        
        public var padding: CGFloat {
            switch self {
            case .none:
                return 0
            case .top, .bottom:
                return 8
            case .center:
                return 16
            }
        }
    }
}

extension PoiStyle {
    public static let amber = PoiStyle(lineColour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                       strokeStyle: StrokeStyle(lineWidth: 2, dash: [5,10]),
                                       font: .caption,
                                       textColour: .black,
                                       background: Color(red: 1.0, green: 0.75, blue: 0.25),
                                       addToLegends: true)
}

/**
 Configurable Point of interest
 */
internal struct YAxisPOI<ChartData>: ViewModifier where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let value: Double
    private let position: PoiPositionable
    private let style: PoiStyle
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        label: String,
        value: Double,
        position: PoiPositionable,
        style: PoiStyle,
        addToLegends: Bool,
        isAverage: Bool
    ) {
        self.chartData = chartData
        self.label = label
        self.value = isAverage ? chartData.average : value
        self.position = position
        self.style = style
        
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal func body(content: Content) -> some View {
        ZStack {
            content
            chartData.yAxisPOIMarker(value: value)
                .trim(to: startAnimation ? 1 : 0)
                .stroke(style.lineColour, style: style.strokeStyle)
            _AxisLabel(chartData: chartData, label: label, value: value, position: position, style: style)
        }
        .animateOnAppear(using: .linear) {
            self.startAnimation = true
        }
        .onDisappear {
            self.startAnimation = false
        }
    }
}

// MARK: - Extensions
extension View {
    /**
     Horizontal line marking a custom value.
     
     Shows a marker line at a specified value.
     */
    public func yAxisPOI<ChartData>(
        chartData: ChartData,
        label: String,
        value: Double,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View
    where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol
    {
        self.modifier(YAxisPOI(chartData: chartData,
                               label: label,
                               value: value,
                               position: position,
                               style: style,
                               addToLegends: addToLegends,
                               isAverage: false))
    }
    
    public func yAxisPOI<ChartData>(
        chartData: ChartData,
        label: String,
        value: Double,
        position: PoiStyle.VerticalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View
    where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol & HorizontalChart
    {
        self.modifier(YAxisPOI(chartData: chartData,
                               label: label,
                               value: value,
                               position: position,
                               style: style,
                               addToLegends: addToLegends,
                               isAverage: false))
    }
    
    /**
     Horizontal line marking the average.
     
     Shows a marker line at the average of all the data points within
     the relevant data set(s).
     */
    public func averageLine<ChartData>(
        chartData: ChartData,
        label: String,
        position: PoiStyle.HorizontalPosition,
        style: PoiStyle,
        addToLegends: Bool = true
    ) -> some View
    where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol & VerticalChart
    {
        self.modifier(YAxisPOI(chartData: chartData,
                               label: label,
                               value: 0,
                               position: position,
                               style: style,
                               addToLegends: addToLegends,
                               isAverage: true))
    }
}

fileprivate struct _AxisLabel<ChartData>: View where ChartData: CTChartData & DataHelper & PointOfInterestProtocol & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let value: Double
    private let position: PoiPositionable
    private let style: PoiStyle
    
    internal init(
        chartData: ChartData,
        label: String,
        value: Double,
        position: PoiPositionable,
        style: PoiStyle
    ) {
        self.chartData = chartData
        self.label = label
        self.value = value
        self.position = position
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geo in
            Text(LocalizedStringKey(label))
                .font(style.font)
                .foregroundColor(style.textColour)
                .padding(position.padding)
                .background(style.background)
                .modifier(_AxisLabel_Shape(position: position, style: style))
                .position(chartData.yAxisPOIMarkerPosition(value: value, position: position, chartSize: geo.size))
                .accessibilityLabel(LocalizedStringKey("P-O-I-Marker"))
                .accessibilityValue(LocalizedStringKey(String(format: NSLocalizedString(label, comment: ""))))
        }
    }
}

fileprivate struct _AxisLabel_Shape: ViewModifier {
    
    let position: PoiPositionable
    let style: PoiStyle
    
    func body(content: Content) -> some View {
        Group {
            switch position.type {
            case .horizontal:
                _AxisLabel_Shape_Horizontal(content: content,
                                            position: position as? PoiStyle.HorizontalPosition,
                                            style: style)
            case .vertical:
                _AxisLabel_Shape_Vertical(content: content,
                                          position: position as? PoiStyle.VerticalPosition,
                                          style: style)
            default:
                content
            }
        }
    }
}

fileprivate struct _AxisLabel_Shape_Horizontal<Content: View>: View {
    
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


fileprivate struct _AxisLabel_Shape_Vertical<Content: View>: View {
    
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
