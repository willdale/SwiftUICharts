//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

// MARK: XAxisLabels
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
        switch position.type {
        case .vertical:
            _Vertical_Labels(chartData: chartData, content: content, data: data, position: position, style: style)
        case .horizontal:
            _Horizontal_Labels(chartData: chartData, content: content, data: data, position: position, style: style)
        default:
            content
        }
    }
}

// MARK: API
extension View {
    /// Labels for the X axis.
    ///
    /// For vertical charts
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        data: XAxisLabelStyle.Data = .datapoints,
        position: VerticalLabelPosition = .bottom,
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
    ///
    /// For horizontal charts
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        data: XAxisLabelStyle.Data = .datapoints,
        position: HorizontalLabelPosition = .leading,
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

extension XAxisLabelStyle {
    public static let standard = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(0))
    
    public static let standard90 = XAxisLabelStyle(font: .caption,
                                                 fontColour: .primary,
                                                 rotation: .degrees(90))
}

public struct XAxisLabelStyle {
    public var font: Font
    public var fontColour: Color
    public var rotation: Angle
    public var padding: CGFloat
    
    public init(
        font: Font = .caption,
        fontColour: Color = .primary,
        rotation: Angle = .degrees(0),
        padding: CGFloat = 8
    ) {
        self.font = font
        self.fontColour = fontColour
        self.rotation = rotation
        self.padding = padding
    }
    
    public enum Data {
        case datapoints
        case custom(labels: [String])
    }
}

// MARK: - Implementation
//
//
//
// MARK: _Vertical_Labels
fileprivate struct _Vertical_Labels<ChartData, Content>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX,
                                                                    Content: View {
    
    @ObservedObject private var chartData: ChartData
    private var content: Content
    private var data: XAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        content: Content,
        data: XAxisLabelStyle.Data,
        position: LabelPositionable,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.content = content
        self.data = data
        self.position = position
        self.style = style
    }
    
    var body: some View {
        switch position as? VerticalLabelPosition {
        case .top:
            VStack(spacing: 0) {
                _Labels(chartData: chartData, data: data, position: position, style: style)
                    .padding(.bottom, style.padding)
                content
            }
        case .bottom:
            VStack(spacing: 0) {
                content
                _Labels(chartData: chartData, data: data, position: position, style: style)
                    .padding(.top, style.padding)
            }
        default:
            content
        }
    }
}

// MARK: _Horizontal_Labels
fileprivate struct _Horizontal_Labels<ChartData, Content>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX,
                                                                      Content: View  {
    
    @ObservedObject private var chartData: ChartData
    private var content: Content
    private var data: XAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        content: Content,
        data: XAxisLabelStyle.Data,
        position: LabelPositionable,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.content = content
        self.data = data
        self.position = position
        self.style = style
    }
    
    var body: some View {
        switch position as? HorizontalLabelPosition {
        case .leading:
            HStack(spacing: 0) {
                _Labels(chartData: chartData, data: data, position: position, style: style)
                    .padding(.trailing, style.padding)
                content
            }
        case .trailing:
            HStack(spacing: 0) {
                content
                _Labels(chartData: chartData, data: data, position: position, style: style)
                    .padding(.leading, style.padding)
            }
        default:
            content
        }
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
        GeometryReader { geo in
            _Labels_SubView(chartData: chartData,
                                data: data,
                                position: position,
                                style: style,
                                frame: geo.frame(in: .local))
        }
        .modifier(_Axis_Label_Size(chartData: chartData, position: position))
    }
}

// MARK: _Labels_Data_Source
fileprivate struct _Labels_SubView<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var data: XAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: XAxisLabelStyle
    private var frame: CGRect
    
    internal init(
        chartData: ChartData,
        data: XAxisLabelStyle.Data,
        position: LabelPositionable,
        style: XAxisLabelStyle,
        frame: CGRect
    ) {
        self.chartData = chartData
        self.data = data
        self.position = position
        self.style = style
        self.frame = frame
    }
    
    var body: some View {
        switch data {
        case .datapoints:
            ForEach(chartData.dataSets.dataLabels.indices, id: \.self) { index in
                _Labels_DataPoints_Cell(chartData: chartData,
                                        label: chartData.dataSets.dataLabels[index],
                                        position: position,
                                        style: style,
                                        index: index,
                                        frame: frame)
            }.border(.red)
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
    }
}

// MARK: Cells
//
//
//
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
            .modifier(_label_Positioning(chartData: chartData, position: position, index: index, frame: frame))
    }
}

// MARK: _Labels_Custom_Cell
fileprivate struct _Labels_Custom_Cell<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
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
//            .frame(width: chartData.xAxisViewData.xAxisLabelWidths.min(),
//                   height: chartData.xAxisViewData.xAxisLabelHeights.max())
        
        if index != count - 1 { 
            Spacer()
                .frame(minWidth: 0, maxWidth: 500)
        }
    }
}

// MARK: View Modifiers
//
//
//
// MARK: _label_Positioning
fileprivate struct _label_Positioning<ChartData>: ViewModifier where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
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
                       height: chartData.xAxisSectionSizing(count: chartData.dataSets.dataWidth, size: frame.height))
                .position(x: (chartData.xAxisViewData.xAxisLabelWidths.max() ?? 0) / 2,
                          y: chartData.xAxisLabelOffSet(index: index, size: frame.height, count: chartData.dataSets.dataWidth))
        case .vertical:
            content
                .frame(width: chartData.xAxisSectionSizing(count: chartData.dataSets.dataWidth, size: frame.width),
                       height: chartData.xAxisViewData.xAxisLabelHeights.max())
                .position(x: chartData.xAxisLabelOffSet(index: index, size: frame.width, count: chartData.dataSets.dataWidth),
                          y: (chartData.xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2)
        default:
            content
        }
    }
}

// MARK: _Axis_Label_Size
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
