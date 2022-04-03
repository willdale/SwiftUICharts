//
//  YAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI
import ChartMath

// MARK: - API
extension View {
    /// Labels for the Y axis.
    public func yAxisLabels(
        position: Set<HorizontalEdge>,
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
        position: Set<VerticalEdge>,
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

// MARK: - Orientation
fileprivate struct _YAxisLabelsModifier_Vertical: ViewModifier {

    @EnvironmentObject var stateObject: ChartStateObject

    let position: [HorizontalEdge]
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle
    let dataSetInfo: DataSetInfo

    var axisOrientation: YAxisLabelStyle.AxisOrientation = .vertical
    

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .leading:
                HStack(spacing: style.padding) {
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                    content
                }
            case .trailing:
                HStack(spacing: style.padding) {
                    content
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                }
            }
        }
    }
}

fileprivate struct _YAxisLabelsModifier_Horizontal: ViewModifier {

    @EnvironmentObject var stateObject: ChartStateObject

    let position: [VerticalEdge]
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle
    let dataSetInfo: DataSetInfo

    let axisOrientation: YAxisLabelStyle.AxisOrientation = .horizontal
    

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .bottom:
                VStack(spacing: style.padding) {
                    content
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                }
            case .top:
                VStack(spacing: style.padding) {
                    YAxisLabels(data: data, style: style, orientation: axisOrientation, dataSetInfo: dataSetInfo)
                    content
                }
            }
        }
    }
}

// MARK: - View
public struct YAxisLabels: View {
    
    @EnvironmentObject var stateObject: ChartStateObject
    @StateObject var state = YAxisLabelsLayoutModel()
    
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle
    let orientation: YAxisLabelStyle.AxisOrientation
    let dataSetInfo: DataSetInfo
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(state: state, label: labels[index], index: index, count: labels.count, style: style)
                    .modifier(_label_Positioning(orientation: state.orientation,
                                                 width: state.widest,
                                                 chartSize: stateObject.chartSize.size,
                                                 index: index,
                                                 count: labels.count))
            }
            .modifier(_Axis_Label_Size(orientation: state.orientation, width: state.widest))
        }
        .onAppear { state.orientation = orientation }
        .onChange(of: state.widest) {
            stateObject.updateLayoutElement(with: ChartStateObject.Model(element: .leadingLabels, value: $0 + style.padding))
            
        }
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
    
    @ObservedObject var state: YAxisLabelsLayoutModel
    let label: String
    let index: Int
    let count: Int
    let style: YAxisLabelStyle
 
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

    var orientation: YAxisLabelStyle.AxisOrientation
    let width: CGFloat
    let chartSize: CGSize
    let index: Int
    let count: Int

    func body(content: Content) -> some View {
        switch orientation {
        case .vertical:
            content
                .frame(width: width,
                       height: divide(chartSize.height, count))
                .position(x: width / 2,
                          y: CGFloat(index) * divide(chartSize.height, count-1))
        case .horizontal:
            content
                .frame(width: divide(chartSize.width, count),
                       height: width)
                .position(x: (CGFloat(index) * divide(chartSize.width, count-1)),
                          y: width / 2)
        }
    }
}

fileprivate struct _Axis_Label_Size: ViewModifier {

    var orientation: YAxisLabelStyle.AxisOrientation
    let width: CGFloat

    func body(content: Content) -> some View {
        switch orientation {
        case .vertical:
            content
                .frame(width: width)
        case .horizontal:
            content
                .frame(height: width)
        }
    }
}
