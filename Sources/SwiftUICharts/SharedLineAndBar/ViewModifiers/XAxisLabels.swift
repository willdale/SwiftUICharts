//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI
import ChartMath

public struct XAxisLabelStyle {
    public var font: Font
    public var fontColour: Color
    public var rotation: Angle
    public var inBounds: Bool
    public var padding: CGFloat
    
    public init(
        font: Font = .caption,
        fontColour: Color = .primary,
        rotation: Angle = .degrees(0),
        inBounds: Bool = true,
        padding: CGFloat = 8
    ) {
        self.font = font
        self.fontColour = fontColour
        self.rotation = rotation
        self.inBounds = inBounds
        self.padding = padding
    }
    
    public enum Data {
        case datapoints
        case custom(labels: [String])
    }
    
    public struct XLabelData {

        public let chart: ChartName
        public let spacing: CGFloat?
        
        public init(
            chart: ChartName,
            spacing: CGFloat? = nil
        ) {
            self.chart = chart
            self.spacing = spacing
        }
    }

    internal enum AxisOrientation {
        case vertical
        case horizontal
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

// MARK: - API
extension View {
    /// Labels for the X axis.
    ///
    /// For vertical charts
    public func xAxisLabels(
        labels: [String],
        positions: Set<HorizontalLabelPosition>,
        style: XAxisLabelStyle = .standard,
        data: XAxisLabelStyle.XLabelData
    ) -> some View
    {
        self.modifier(
            _XAxisLabelsModifier_Vertical(
                labels: labels,
                positions: Array(positions),
                style: style,
                data: data
            )
        )
    }
    
    /// Labels for the X axis.
    ///
    /// For horizontal charts
    public func xAxisLabels(
        labels: [String],
        positions: Set<VerticalLabelPosition>,
        style: XAxisLabelStyle = .standard,
        data: XAxisLabelStyle.XLabelData
    ) -> some View
    {
        self.modifier(
            _XAxisLabelsModifier_Horizontal (
                labels: labels,
                positions: Array(positions),
                style: style,
                data: data
            )
        )
    }
}

// MARK: - AxisOrientation
fileprivate struct _XAxisLabelsModifier_Vertical: ViewModifier {

    let labels: [String]
    let positions: [HorizontalLabelPosition]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData
    
    let axisOrientation: XAxisLabelStyle.AxisOrientation = .horizontal
    
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .leading:
                HStack(spacing: style.padding) {
                    XAxisLabels(labels: labels, style: style, data: data, orientation: axisOrientation)
                    content
                }
            case .trailing:
                HStack(spacing: style.padding) {
                    content
                    XAxisLabels(labels: labels, style: style, data: data, orientation: axisOrientation)
                }
            }
        }
    }
}

fileprivate struct _XAxisLabelsModifier_Horizontal: ViewModifier {

    let labels: [String]
    let positions: [VerticalLabelPosition]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData

    let axisOrientation: XAxisLabelStyle.AxisOrientation = .vertical
    
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .bottom:
                VStack(spacing: style.padding) {
                    content
                    XAxisLabels(labels: labels, style: style, data: data, orientation: axisOrientation)
                }
            case .top:
                VStack(spacing: style.padding) {
                    XAxisLabels(labels: labels, style: style, data: data, orientation: axisOrientation)
                    content
                }
            }
        }
    }
}

// MARK: - View
public struct XAxisLabels: View {
    
    @EnvironmentObject var stateObject: TestStateObject
    @StateObject var state = XAxisLabelsLayoutModel()
    
    let labels: [String]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData
    
    let orientation: XAxisLabelStyle.AxisOrientation
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _label_Cell(state: state, label: labels[index], style: style, index: index)
                    .modifier(_label_Positioning(state: state,
                                                 data: data,
                                                 index: index,
                                                 count: labels.count,
                                                 size: stateObject.chartSize.size,
                                                 minLabel: state.minWidth,
                                                 padding: state.maxWidth,
                                                 inBounds: style.inBounds))
            }
            .modifier(_Axis_Label_Size(state: state))
        }
        .onAppear {
            state.orientation = orientation
            state.isRotated = style.rotation.degrees != 0 || style.rotation.radians != 0
        }
    }
}

// MARK: Cell
fileprivate struct _label_Cell: View {
    
    @ObservedObject var state: XAxisLabelsLayoutModel
    let label: String
    let style: XAxisLabelStyle
    let index: Int
    
    
    var body: some View {
        Text(LocalizedStringKey(label))
            .font(style.font)
            .foregroundColor(style.fontColour)
        
            .fixedSize()
            .rotationEffect(style.rotation, anchor: .center)
        
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            let width: CGFloat
                            let height: CGFloat
                            switch state.orientation {
                            case .vertical:
                                width = geo.frame(in: .local).width
                                height = geo.frame(in: .local).height
                            case .horizontal:
                                width = geo.frame(in: .local).height
                                height = geo.frame(in: .local).width
                            }
                            state.update(with: XAxisLabelsLayoutModel.Model(id: index, width: width, height: height))
                        }
                }
            )
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: - ViewModifiers
fileprivate struct _label_Positioning: ViewModifier {
    
    @ObservedObject var state: XAxisLabelsLayoutModel
    let data: XAxisLabelStyle.XLabelData
    let index: Int
    let count: Int
    let size: CGSize
    let minLabel: CGFloat
    let padding: CGFloat
    let inBounds: Bool
    
    func body(content: Content) -> some View {
        switch state.orientation {
        case .vertical:
            content
                .frame(width: _XAxisMath.xAxisSectionSizing(data: data,
                                                           count: count,
                                                           size: size.width,
                                                           minLabel: state.minWidth,
                                                           padding: inBounds ? state.maxWidth : 0),
                       height: state.isRotated ? state.maxWidth : state.maxHeight)
                .position(x: _XAxisMath.xAxisLabelOffSet(data: data,
                                                        index: index,
                                                        count: count,
                                                        size: size.width,
                                                        minLabel: state.minWidth,
                                                        padding: inBounds ? state.width(for: index) : 0),
                          y: state.isRotated ? state.width(for: index) / 2 : state.maxHeight / 2)
        case .horizontal:
            content
                .frame(width: state.maxWidth,
                       height: divide(size.height, count))
                .position(x: state.maxWidth / 2,
                          y: (CGFloat(index) * divide(size.height, count-1)))
        }
    }
}

fileprivate struct _Axis_Label_Size: ViewModifier {

    @ObservedObject var state: XAxisLabelsLayoutModel

    func body(content: Content) -> some View {
        switch state.orientation {
        case .vertical:
            content
                .frame(height: state.maxHeight)
        case .horizontal:
            content
                .frame(width: state.maxWidth)
        }
    }
}

// MARK: - Layout Model
internal final class XAxisLabelsLayoutModel: ObservableObject  {
        
    @Published internal var sizes = Set<Model>()
    @Published internal var maxWidth: CGFloat = 0
    @Published internal var maxHeight: CGFloat = 0
    @Published internal var minWidth: CGFloat = 0
    @Published internal var isRotated: Bool = false
    
    internal var orientation: XAxisLabelStyle.AxisOrientation = .vertical
    
        
    internal func update(with newItem: Model) {
        if let oldItem = sizes.first(where: { $0.id == newItem.id }) {
            sizes.remove(oldItem)
            sizes.insert(newItem)
        } else {
            sizes.insert(newItem)
        }
        maxWidth = sizes
            .map(\.width)
            .max() ?? 0
        maxHeight = sizes
            .map(\.height)
            .max() ?? 0
        
        minWidth = sizes
            .map(\.height)
            .min() ?? 0
    }
    
    internal func width(for index: Int) -> CGFloat {
        return sizes.first(where: { $0.id == index })?.width ?? 0
    }
    
    internal struct Model: Hashable {
        internal let id: Int
        internal let width: CGFloat
        internal let height: CGFloat
    }
}

// MARK: - Math
fileprivate enum _XAxisMath {
    static internal func xAxisSectionSizing(
        data: XAxisLabelStyle.XLabelData,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat
    ) -> CGFloat {
        switch data.chart {
        case .line,
             .filledLine,
             .multiLine,
             .rangedLine:
            let section = divide(size - padding, count)
            let value = min(section, minLabel)
            return value > 0 ? value : 0
            
        case .bar,
             .rangedBar,
             .stackedBar,
             .horizontalBar:
            let value = divide(size - padding, count)
            return value > 0 ? value : 0
            
        case .groupedBar:
            let superXSection = divide(size - padding, count)
            let spaceSection = (data.spacing ?? 0) * CGFloat(count - 1)
            let compensation = divide(spaceSection, count)
            let section = superXSection - compensation
            return section > 0 ? section : 0
            
        default:
            return .zero
        }
    }
    
    static internal func xAxisLabelOffSet(
        data: XAxisLabelStyle.XLabelData,
        index: Int,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat
    ) -> CGFloat {
        switch data.chart {
        case .line,
             .filledLine,
             .multiLine,
             .rangedLine:
            return (CGFloat(index) * divide(size - padding, count - 1)) + (padding / 2)
            
        case .bar,
             .rangedBar,
             .stackedBar,
             .horizontalBar:
            let value = CGFloat(index) * divide(size - padding, count)
            let offSet = xAxisSectionSizing(data: data, count: count, size: size, minLabel: minLabel, padding: padding) / 2
            let pad = padding / 2
            return value + offSet + pad
            
        case .groupedBar:
            let superXSection = divide(size - padding, count)
            let compensation = (((data.spacing ?? 0) * CGFloat(count - 1)) / CGFloat(count))
            let section = (CGFloat(index) * superXSection) + ((CGFloat(index) * compensation) / CGFloat(count))
            let offSet = xAxisSectionSizing(data: data, count: count, size: size, minLabel: minLabel, padding: padding) / 2
            let pad = padding / 2
            return section + offSet + pad
        default:
            return .zero
        }
    }
}
