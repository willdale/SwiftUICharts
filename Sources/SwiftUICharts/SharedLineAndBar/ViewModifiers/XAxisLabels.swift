//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

public protocol LabelPositionable {}

extension LabelPositionable {
    internal var type: _LabelPositionType {
        switch self {
        case is XAxisLabelStyle.HorizontalPosition:
            return .horizontal
        case is XAxisLabelStyle.VerticalPosition:
            return .vertical
        default:
            return .none
        }
    }
}

internal enum _LabelPositionType {
    case none
    case horizontal
    case vertical
}

public struct XAxisLabelStyle {
    public var font: Font
    public var fontColour: Color
    public var rotation: Angle
    
    public init(
        font: Font = .caption, 
        fontColour: Color = .primary, 
        rotation: Angle = .degrees(0)
    ) {
        self.font = font
        self.fontColour = fontColour
        self.rotation = rotation
    }
    
    public enum HorizontalPosition: LabelPositionable {
        case none
        case leading
        case trailing
    }
    
    public enum VerticalPosition: LabelPositionable {
        case none
        case top
        case bottom
    }
    
    public enum Data {
        case datapoints
        case custom(labels: [String])
    }
}

extension XAxisLabelStyle {
    public static let standard = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(0))
    
    public static let standard90 = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(90))
}

internal struct XAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & AxisX & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var data: XAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        data: XAxisLabelStyle.Data,
        position: LabelPositionable,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.position = position
        self.style = style
        
        self.chartData.xAxisViewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch position.type {
            case .vertical:
                switch position as? XAxisLabelStyle.VerticalPosition {
                case .top:
                    VStack {
                        _Labels(chartData: chartData, data: data, position: position, style: style)
                        content
                    }
                case .bottom:
                    VStack {
                        content
                        _Labels(chartData: chartData, data: data, position: position, style: style)
                    }
                default:
                    content
                }
            case .horizontal:
                switch position as? XAxisLabelStyle.HorizontalPosition {
                case .leading:
                    HStack {
                        _Labels(chartData: chartData, data: data, position: position, style: style)
                        content
                    }
                case .trailing:
                    HStack {
                        content
                        _Labels(chartData: chartData, data: data, position: position, style: style)
                    }
                default:
                    content
                }
            default:
                content
            }
        }
    }
}

extension View {
    /// Labels for the X axis.
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        data: XAxisLabelStyle.Data = .datapoints,
        position: XAxisLabelStyle.VerticalPosition = .bottom,
        style: XAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & AxisX & ViewDataProtocol
    {
        self.modifier(
            XAxisLabels(
                chartData: chartData,
                data: data,
                position: position,
                style: style
            )
        )
    }
    
    /// Labels for the X axis.
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        data: XAxisLabelStyle.Data = .datapoints,
        position: XAxisLabelStyle.HorizontalPosition = .leading,
        style: XAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & AxisX & ViewDataProtocol & HorizontalChart
    {
        self.modifier(
            XAxisLabels(
                chartData: chartData,
                data: data,
                position: position,
                style: style
            )
        )
    }
}

// MARK: _Labels
fileprivate struct _Labels<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var data: XAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        data: XAxisLabelStyle.Data,
        position: LabelPositionable,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.position = position
        self.style = style
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                
                switch data {
                case .datapoints:
                    ForEach(chartData.dataSets.dataLabels.indices, id: \.self) { index in
                        _Labels_DataPoints_Cell(chartData: chartData,
                                                label: chartData.dataSets.dataLabels[index],
                                                position: position,
                                                style: style,
                                                index: index,
                                                frame: geo.frame(in: .local))
                    }
                case .custom(let labels):
                    HStack(spacing: 0) {
                        ForEach(labels.indices, id: \.self) { index in
                            _Labels_Custom_Cell(chartData: chartData,
                                                label: labels[index],
                                                position: position,
                                                style: style,
                                                index: index,
                                                count: labels.count)
                        }
                    }
                }
                
            }.modifier(_Axis_Label_Size(chartData: chartData, position: position))
        }
    }
}

// MARK: _Labels_DataPoints_Cell
fileprivate struct _Labels_DataPoints_Cell<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var label: String
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    private var index: Int
    private var frame: CGRect
    
    internal init(
        chartData: ChartData,
        label: String,
        position: LabelPositionable,
        style: XAxisLabelStyle,
        index: Int,
        frame: CGRect
    ) {
        self.chartData = chartData
        self.label = label
        self.position = position
        self.style = style
        self.index = index
        self.frame = frame
    }
    
    var body: some View {
        RotatedText(chartData: chartData, label: label, position: position, style: style)
            .modifier(_label_Size(chartData: chartData, position: position, index: index, frame: frame))
    }
}

fileprivate struct _label_Size<ChartData>: ViewModifier where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var position: LabelPositionable
    private var index: Int
    private var frame: CGRect
    
    internal init(
        chartData: ChartData,
        position: LabelPositionable,
        index: Int,
        frame: CGRect
    ) {
        self.chartData = chartData
        self.position = position
        self.index = index
        self.frame = frame
    }
    
    func body(content: Content) -> some View {
        switch position.type {
        case .horizontal:
            content
                .frame(width: chartData.xAxisViewData.xAxisLabelWidths.max(),
                       height: chartData.sectionX(count: chartData.dataSets.dataWidth, size: frame.height))
                .offset(x: 0,
                        y: chartData.xAxisLabelOffSet(index: index, size: frame.height, count: chartData.dataSets.dataWidth))
        case .vertical:
            content
                .frame(width: chartData.sectionX(count: chartData.dataSets.dataWidth, size: frame.width),
                       height: chartData.xAxisViewData.xAxisLabelHeights.max())
                .offset(x: chartData.xAxisLabelOffSet(index: index, size: frame.width, count: chartData.dataSets.dataWidth),
                        y: 0)
        default:
            content
        }
    }
}

fileprivate struct _Axis_Label_Size<ChartData>: ViewModifier where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var position: LabelPositionable
    
    internal init(
        chartData: ChartData,
        position: LabelPositionable
    ) {
        self.chartData = chartData
        self.position = position
    }
    
    func body(content: Content) -> some View {
        switch position.type {
        case .vertical:
            content
                .frame(height: chartData.xAxisViewData.xAxisLabelHeights.max())
        case .horizontal:
            content
                .frame(width: chartData.xAxisViewData.xAxisLabelWidths.max())
        default:
            content
        }
    }
}

// MARK: _Labels_Custom_Cell
fileprivate struct _Labels_Custom_Cell<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var label: String
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    private var index: Int
    private var count: Int
    
    internal init(
        chartData: ChartData,
        label: String,
        position: LabelPositionable,
        style: XAxisLabelStyle,
        index: Int,
        count: Int
    ) {
        self.chartData = chartData
        self.label = label
        self.position = position
        self.style = style
        self.index = index
        self.count = count
    }
    
    var body: some View {
        RotatedText(chartData: chartData, label: label, position: position, style: style)
            .frame(width: chartData.xAxisViewData.xAxisLabelWidths.min(),
                   height: chartData.xAxisViewData.xAxisLabelHeights.max())
        if index != count - 1 {
            Spacer()
                .frame(minWidth: 0, maxWidth: 500)
        }
    }
}
