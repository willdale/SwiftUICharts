//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI
import ChartMath

// MARK: - TODO:
// fix layout in horizontal charts



// MARK: - API
extension View {
    /// Labels for the Y axis.
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        position: Set<HorizontalLabelPosition>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & DataHelper & VerticalChart
    {
        self.modifier(
            _YAxisLabelsModifier_Vertical(
                chartData: chartData,
                position: Array(position),
                data: data,
                style: style
            )
        )
    }

    /// Labels for the Y axis.
    public func yAxisLabels<ChartData>(
        chartData: ChartData,
        position: Set<VerticalLabelPosition>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & DataHelper & HorizontalChart
    {
        self.modifier(
            _YAxisLabelsModifier_Horizontal(
                chartData: chartData,
                position: Array(position),
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

public enum AxisOrientation {
    case vertical
    case horizontal
}


// MARK: - View
public struct YAxisLabels<ChartData>: View where ChartData: CTChartData & DataHelper {

    @ObservedObject private var chartData: ChartData
    @StateObject private var state = YAxisLabelsLayoutModel()
    
    private let data: YAxisLabelStyle.Data
    private let style: YAxisLabelStyle
    private let orientation: AxisOrientation
    
    public init(
        _ chartData: ChartData,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle,
        orientation: AxisOrientation
    ) {
        self.chartData = chartData
        self.data = data
        self.style = style
        self.orientation = orientation
    }
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(state: state, label: labels[index], index: index, count: labels.count, style: style)
                    .modifier(_label_Positioning(state: state,
                                                 index: index,
                                                 count: labels.count,
                                                 chartSize: chartData.chartSize))
            }
            .modifier(_Axis_Label_Size(state: state))
        }
        .onAppear { state.orientation = orientation }
    }
    
    internal var labels: [String] {
        switch data {
        case .generated:
            guard let firstLabel = style.formatter.string(from: NSNumber(value: chartData.minValue)) else { return [] }
            let otherLabels: [String] = (1...style.number-1).compactMap {
                let value = chartData.minValue + divide(chartData.range, style.number-1) * Double($0)
                guard let formattedNumber = style.formatter.string(from: NSNumber(value: value)) else { return nil }
                return formattedNumber
            }
            return ([firstLabel] + otherLabels).reversed()
        case .custom(let labels):
            return labels.reversed()
        }
    }
}

// MARK: Cell
fileprivate struct _Label_Cell: View {

    @ObservedObject private var state: YAxisLabelsLayoutModel
    private let label: String
    private let index: Int
    private let count: Int
    private let style: YAxisLabelStyle
    
    internal init(
        state: YAxisLabelsLayoutModel,
        label: String,
        index: Int,
        count: Int,
        style: YAxisLabelStyle
    ) {
        self.state = state
        self.label = label
        self.index = index
        self.count = count
        self.style = style
    }
        
    var body: some View {
        Text(LocalizedStringKey(label))
            .font(style.font)
            .foregroundColor(style.colour)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            let value: CGFloat
                            switch state.orientation {
                            case .vertical:
                                value = geo.frame(in: .local).width
                            case .horizontal:
                                value = geo.frame(in: .local).height
                            }
                            state.update(with: YAxisLabelsLayoutModel.Model(id: index, value: value))
                        }
                }
            )
            .fixedSize()
            .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: - ViewModifiers
fileprivate struct _label_Positioning: ViewModifier {

    @ObservedObject var state: YAxisLabelsLayoutModel
    var index: Int
    var count: Int

    var chartSize: CGRect

    func body(content: Content) -> some View {
        switch state.orientation {
        case .vertical:
            content
                .frame(width: state.widest,
                       height: divide(chartSize.height, count))
                .position(x: state.widest / 2,
                          y: CGFloat(index) * divide(chartSize.height, count-1))
        case .horizontal:
            content
                .frame(width: divide(chartSize.width, count),
                       height: state.widest)
                .position(x: (CGFloat(index) * divide(chartSize.width, count-1)),
                          y: state.widest / 2)
        }
    }

    func test() -> CGFloat {
        return .zero
    }
}

fileprivate struct _Axis_Label_Size: ViewModifier {

    @ObservedObject var state: YAxisLabelsLayoutModel

    func body(content: Content) -> some View {
        switch state.orientation {
        case .vertical:
            content
                .frame(width: state.widest)
        case .horizontal:
            content
                .frame(height: state.widest)
        }
    }
}

// MARK: - AxisOrientation
fileprivate struct _YAxisLabelsModifier_Horizontal<ChartData>: ViewModifier where ChartData: CTChartData & DataHelper {

    var chartData: ChartData
    var position: [VerticalLabelPosition]
    var data: YAxisLabelStyle.Data
    var style: YAxisLabelStyle = .standard

    var axisOrientation: AxisOrientation = .horizontal

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .bottom:
                VStack {
                    content
                    YAxisLabels(chartData, data: data, style: style, orientation: axisOrientation)
                }
            case .top:
                VStack {
                    YAxisLabels(chartData, data: data, style: style, orientation: axisOrientation)
                    content
                }
            default:
                content
            }
        }
    }
}

fileprivate struct _YAxisLabelsModifier_Vertical<ChartData>: ViewModifier where ChartData: CTChartData & DataHelper {

    var chartData: ChartData
    var position: [HorizontalLabelPosition]
    var data: YAxisLabelStyle.Data
    var style: YAxisLabelStyle = .standard

    var axisOrientation: AxisOrientation = .vertical

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .leading:
                HStack {
                    YAxisLabels(chartData, data: data, style: style, orientation: axisOrientation)
                    content
                }
            case .trailing:
                HStack {
                    content
                    YAxisLabels(chartData, data: data, style: style, orientation: axisOrientation)
                }
            default:
                content
            }
        }
    }
}

// MARK: - LayoutModel
internal final class YAxisLabelsLayoutModel: ObservableObject  {
        
    @Published internal var widths = Set<Model>()
    @Published internal var widest: CGFloat = 0
    
    var orientation: AxisOrientation = .vertical
        
    internal func update(with newItem: Model) {
        if let oldItem = widths.first(where: { $0.id == newItem.id }) {
            widths.remove(oldItem)
            widths.insert(newItem)
        } else {
            widths.insert(newItem)
        }
        widest = widths.map(\.value).max() ?? 0
    }
    
    internal struct Model: Hashable {
        internal let id: Int
        internal let value: CGFloat
    }
}
