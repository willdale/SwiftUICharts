//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI
import ChartMath

// MARK: - API
extension View {
    /// Labels for the X axis.
    ///
    /// For vertical charts
    public func xAxisLabels(
        labels: [String],
        positions: Set<HorizontalEdge>,
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
        positions: Set<VerticalEdge>,
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
    let positions: [HorizontalEdge]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData
        
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .leading:
                HStack(spacing: style.padding) {
                    XAxisLabels(labels: labels, style: style, data: data, orientation: .horizontal)
                    content
                }
            case .trailing:
                HStack(spacing: style.padding) {
                    content
                    XAxisLabels(labels: labels, style: style, data: data, orientation: .horizontal)
                }
            }
        }
    }
}

fileprivate struct _XAxisLabelsModifier_Horizontal: ViewModifier {

    let labels: [String]
    let positions: [VerticalEdge]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData
    
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .bottom:
                VStack(spacing: style.padding) {
                    content
                    XAxisLabels(labels: labels, style: style, data: data, orientation: .vertical)
                }
            case .top:
                VStack(spacing: style.padding) {
                    XAxisLabels(labels: labels, style: style, data: data, orientation: .vertical)
                    content
                }
            }
        }
    }
}

// MARK: - View
public struct XAxisLabels: View {
    
    @EnvironmentObject private var stateObject: ChartStateObject
    @StateObject private var state = XAxisLabelsLayoutModel()
    
    let labels: [String]
    let style: XAxisLabelStyle
    let data: XAxisLabelStyle.XLabelData
    
    let orientation: XAxisLabelStyle.AxisOrientation
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _label_Cell(state: state, label: labels[index], style: style, index: index)
                    .modifier(
                        _label_Positioning(
                            state: state,
                            data: data,
                            index: index,
                            count: labels.count,
                            size: stateObject.chartSize.size,
                            minLabel: state.minWidth,
                            padding: state.maxWidth,
                            inBounds: style.inBounds
                        )
                    )
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
                .frame(
                    width: XAxisLabelsLayoutModel.xAxisSectionSizing(
                        data: data,
                        count: count,
                        size: size.width,
                        minLabel: state.minWidth,
                        padding: inBounds ? state.maxWidth : 0
                    ),
                    height: state.isRotated ? state.maxWidth : state.maxHeight
                )
                .position(
                    x: XAxisLabelsLayoutModel.xAxisLabelOffSet(
                        data: data,
                        index: index,
                        count: count,
                        size: size.width,
                        minLabel: state.minWidth,
                        padding: inBounds ? state.width(for: index) : 0
                    ),
                    y: state.isRotated ? state.width(for: index) / 2 : state.maxHeight / 2
                )
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
