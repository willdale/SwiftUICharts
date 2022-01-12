//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

// MARK: YAxisLabels
internal struct YAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper {
    
    @ObservedObject private var chartData: ChartData
    private var position: LabelPositionable
    private var data: YAxisLabelStyle.Data
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        position: LabelPositionable,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.position = position
        self.data = data
        self.style = style
        
        self.chartData.yAxisViewData.hasYAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        switch position.type {
        case .horizontal:
            _Horizontal_Labels(chartData: chartData, content: content, data: data, position: position, style: style)
        case .vertical:
            _Vertical_Labels(chartData: chartData, content: content, data: data, position: position, style: style)
        default:
            content
        }
    }
}

// MARK: API
extension View {
    /// Labels for the X axis.
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        position: HorizontalLabelPosition,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper & VerticalChart
    {
        self.modifier(
            YAxisLabels(
                chartData: chartData,
                position: position,
                data: data,
                style: style
            )
        )
    }
    
    /// Labels for the X axis.
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        position: VerticalLabelPosition,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper & HorizontalChart
    {
        self.modifier(
            YAxisLabels(
                chartData: chartData,
                position: position,
                data: data,
                style: style
            )
        )
    }
}

public struct YAxisLabelStyle {
    public var font: Font
    public var colour: Color
    public var number: Int
    public var formatter: NumberFormatter
    public var padding: CGFloat
    
    public init(
        font: Font = .caption,
        colour: Color = .primary,
        number: Int = 10,
        formatter: NumberFormatter = .default,
        padding: CGFloat = 8
    ) {
        self.font = font
        self.colour = colour
        self.number = number
        self.formatter = formatter
        self.padding = padding
    }
    
    public enum Data {
        case generated
        case custom(labels: [String])
    }
}

extension YAxisLabelStyle {
    public static let standard = YAxisLabelStyle(font: .caption,
                                                 colour: .primary,
                                                 number: 10,
                                                 formatter: .default)
}

// MARK: - Implementation
//
//
//
// MARK: _Vertical_Labels
fileprivate struct _Vertical_Labels<ChartData, Content>: View where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper,
                                                                    Content: View {
    
    @ObservedObject private var chartData: ChartData
    private var content: Content
    private var data: YAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        content: Content,
        data: YAxisLabelStyle.Data,
        position: LabelPositionable,
        style: YAxisLabelStyle
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
            VStack {
                _Labels(chartData: chartData, data: data, position: position, style: style)
                    .padding(.bottom, style.padding)
                content
            }
        case .bottom:
            VStack {
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
fileprivate struct _Horizontal_Labels<ChartData, Content>: View where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper,
                                                                      Content: View  {
    
    @ObservedObject private var chartData: ChartData
    private var content: Content
    private var data: YAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        content: Content,
        data: YAxisLabelStyle.Data,
        position: LabelPositionable,
        style: YAxisLabelStyle
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

fileprivate struct _Labels<ChartData>: View where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper {
    
    @ObservedObject private var chartData: ChartData
    private var data: YAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        data: YAxisLabelStyle.Data,
        position: LabelPositionable,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.position = position
        self.style = style
    }
    
    var body: some View {
        _Labels_SubView(chartData: chartData, data: data, position: position, style: style)
            .modifier(_Axis_Label_Size(chartData: chartData, position: position))
    }
}

// MARK: _Labels
fileprivate struct _Labels_SubView<ChartData>: View where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper {
    
    @ObservedObject private var chartData: ChartData
    private var data: YAxisLabelStyle.Data
    private var position: LabelPositionable
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        data: YAxisLabelStyle.Data,
        position: LabelPositionable,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.position = position
        self.style = style
    }
    
    var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(chartData: chartData, label: labels[index], style: style)
                    .modifier(_label_Positioning(chartData: chartData, position: position, style: style, index: index, count: labels.count, frame: chartData.chartSize))
            }
        }
        .border(.blue)
    }
    
    private var labels: [String] {
        switch data {
        case .generated:
            guard let firstLabel = style.formatter.string(from: NSNumber(value: chartData.minValue)) else { return [] }
            let otherLabels: [String] = (1...style.number-1).compactMap {
                let value = chartData.minValue + (chartData.range / Double(style.number-1)) * Double($0)
                guard let formattedNumber = style.formatter.string(from: NSNumber(value: value)) else { return nil }
                return formattedNumber
            }
            return position.isHorizontal ? ([firstLabel] + otherLabels).reversed() : ([firstLabel] + otherLabels)
        case .custom(let labels):
            return position.isHorizontal ? labels.reversed() : labels
        }
    }
}

// MARK: _Label_Cell
fileprivate struct _Label_Cell<ChartData>: View where ChartData: CTChartData & YAxisViewDataProtocol & AxisY & DataHelper {
    
    @ObservedObject private var chartData: ChartData
    private var label: String
    private var style: YAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        label: String,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.label = label
        self.style = style
    }
    
    var body: some View {
        Text(LocalizedStringKey(label))
            .font(style.font)
            .foregroundColor(style.colour)
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .onAppear {
                            chartData.yAxisViewData.yAxisLabelWidths.append(geo.size.width)
                            chartData.yAxisViewData.yAxisLabelHeights.append(geo.size.height)
                        }
                }
            )
            .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: View Modifiers
//
//
//
// MARK: _label_Positioning
fileprivate struct _label_Positioning<ChartData>: ViewModifier where ChartData: CTChartData & ViewDataProtocol & AxisY {
    
    @ObservedObject private var chartData: ChartData
    private var position: LabelPositionable
    private var style: YAxisLabelStyle
    private var index: Int
    private var count: Int
    private var frame: CGRect
    
    internal init(
        chartData: ChartData,
        position: LabelPositionable,
        style: YAxisLabelStyle,
        index: Int,
        count: Int,
        frame: CGRect
    ) {
        self.chartData = chartData
        self.position = position
        self.style = style
        self.index = index
        self.count = count
        self.frame = frame
    }
    
    func body(content: Content) -> some View {
        switch position.type {
        case .horizontal:
            content
                .frame(width: chartData.yAxisViewData.yAxisLabelWidths.max(),
                       height: chartData.yAxisSectionSizing(count: count, size: frame.height))
                .position(x: (chartData.yAxisViewData.yAxisLabelWidths.max() ?? 0) / 2,
                          y: chartData.yAxisLabelOffSet(index: index,
                                                       size: frame.height,
                                                       count: count))
        case .vertical:
            content
                .frame(width: chartData.yAxisSectionSizing(count: count, size: frame.width),
                       height: chartData.yAxisViewData.yAxisLabelHeights.max())
                .position(x: (chartData.xAxisViewData.xAxisLabelWidths.max() ?? 0) + style.padding + chartData.yAxisLabelOffSet(index: index, size: frame.width, count: count),
                          y: (chartData.yAxisViewData.yAxisLabelWidths.max() ?? 0) / 2)
        default:
            content
        }
    }
}

// MARK: _Axis_Label_Size
fileprivate struct _Axis_Label_Size<ChartData>: ViewModifier where ChartData: CTChartData & YAxisViewDataProtocol & AxisY {
    
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
                .frame(height: chartData.yAxisViewData.yAxisLabelHeights.max())
        case .horizontal:
            content
                .frame(width: chartData.yAxisViewData.yAxisLabelWidths.max())
        default:
            content
        }
    }
}
