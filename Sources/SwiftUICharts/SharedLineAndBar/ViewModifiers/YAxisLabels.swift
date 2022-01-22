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
// Add padding to the chart size

public struct DataSetInfo {
    public let minValue: Double
    public let range: Double
    
    public init(
        minValue: Double,
        range: Double
    ) {
        self.minValue = minValue
        self.range = range
    }
}


// MARK: - API
extension View {
    /// Labels for the Y axis.
    public func yAxisLabels(
        position: Set<HorizontalLabelPosition>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard,
        dataSetInfo: DataSetInfo
    ) -> some View
    {
        self.modifier(
            _YAxisLabelsModifier_Vertical(
                position: Array(position),
                data: data,
                style: style,
                dataSetInfo: dataSetInfo
            )
        )
    }

    /// Labels for the Y axis.
    public func yAxisLabels(
        position: Set<VerticalLabelPosition>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard,
        dataSetInfo: DataSetInfo
    ) -> some View
    {
        self.modifier(
            _YAxisLabelsModifier_Horizontal(
                position: Array(position),
                data: data,
                style: style,
                dataSetInfo: dataSetInfo
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
public struct YAxisLabels:View {
    
    @EnvironmentObject var stateObject: TestStateObject
    @StateObject var state = YAxisLabelsLayoutModel()
    
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle
    let orientation: AxisOrientation
    let dataSetInfo: DataSetInfo
    
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(state: state, label: labels[index], index: index, count: labels.count, style: style)
                    .modifier(_label_Positioning(state: state,
                                                 index: index,
                                                 count: labels.count,
                                                 chartSize: stateObject.chartSize))
            }
            .modifier(_Axis_Label_Size(state: state))
        }
        .onAppear { state.orientation = orientation }
        .onChange(of: state.widest) { stateObject.leadingInset = $0 }
    }
    
    internal var labels: [String] {
        switch data {
        case .generated:
            guard let firstLabel = style.formatter.string(from: NSNumber(value: dataSetInfo.minValue)) else { return [] }
            let otherLabels: [String] = (1...style.number-1).compactMap {
                let value = dataSetInfo.minValue + divide(dataSetInfo.range, style.number-1) * Double($0)
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
fileprivate struct _YAxisLabelsModifier_Horizontal: ViewModifier {

    @EnvironmentObject var stateObject: TestStateObject

    var position: [VerticalLabelPosition]
    var data: YAxisLabelStyle.Data
    var style: YAxisLabelStyle = .standard

    var axisOrientation: AxisOrientation = .horizontal
    
    let dataSetInfo: DataSetInfo

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .bottom:
                VStack(spacing: 0) {
                    content
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                }
            case .top:
                VStack(spacing: 0) {
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                    content
                }
            default:
                content
            }
        }
    }
}

fileprivate struct _YAxisLabelsModifier_Vertical: ViewModifier {

    @EnvironmentObject var stateObject: TestStateObject

    var position: [HorizontalLabelPosition]
    var data: YAxisLabelStyle.Data
    var style: YAxisLabelStyle = .standard

    var axisOrientation: AxisOrientation = .vertical
    
    let dataSetInfo: DataSetInfo

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .leading:
                HStack(spacing: 0) {
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                    content
                }
            case .trailing:
                HStack(spacing: 0) {
                    content
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
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
