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
    public func yAxisLabels<ChartData: CTChartData & DataHelper>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        position: Set<HorizontalEdge>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View {
        self.modifier(
            _YAxisLabelsModifier_Vertical(
                chartData: chartData,
                stateObject: stateObject,
                position: Array(position),
                data: data,
                style: style
            )
        )
    }

    /// Labels for the Y axis.
    public func yAxisLabels<ChartData: CTChartData & DataHelper>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        position: Set<VerticalEdge>,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle = .standard
    ) -> some View {
        self.modifier(
            _YAxisLabelsModifier_Horizontal(
                chartData: chartData,
                stateObject: stateObject,
                position: Array(position),
                data: data,
                style: style
            )
        )
    }
}

// MARK: - Orientation
fileprivate struct _YAxisLabelsModifier_Vertical<ChartData: CTChartData & DataHelper>: ViewModifier {

    let chartData: ChartData
    let stateObject: ChartStateObject
    let position: [HorizontalEdge]
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle

    var axisOrientation: YAxisLabelStyle.AxisOrientation = .vertical
    

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .leading:
                HStack(spacing: style.padding) {
                    YAxisLabels(chartData: chartData, stateObject: stateObject, data: data, style: style, orientation: axisOrientation)
                    content
                }
            case .trailing:
                HStack(spacing: style.padding) {
                    content
                    YAxisLabels(chartData: chartData, stateObject: stateObject, data: data, style: style, orientation: axisOrientation)
                }
            }
        }
    }
}

fileprivate struct _YAxisLabelsModifier_Horizontal<ChartData: CTChartData & DataHelper>: ViewModifier {

    let chartData: ChartData
    let stateObject: ChartStateObject
    let position: [VerticalEdge]
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle

    let axisOrientation: YAxisLabelStyle.AxisOrientation = .horizontal
    

    func body(content: Content) -> some View {
        ForEach(position) { pos in
            switch pos {
            case .bottom:
                VStack(spacing: style.padding) {
                    content
                    YAxisLabels(chartData: chartData, stateObject: stateObject, data: data, style: style, orientation: axisOrientation)
                }
            case .top:
                VStack(spacing: style.padding) {
                    YAxisLabels(chartData: chartData, stateObject: stateObject, data: data, style: style, orientation: axisOrientation)
                    content
                }
            }
        }
    }
}

// MARK: - View
public struct YAxisLabels<ChartData: CTChartData & DataHelper>: View {
    
    let chartData: ChartData
    @StateObject var localState = YAxisLabelsLayoutModel()
    let stateObject: ChartStateObject
    
    let data: YAxisLabelStyle.Data
    let style: YAxisLabelStyle
    let orientation: YAxisLabelStyle.AxisOrientation
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(localState: localState, label: labels[index], index: index, count: labels.count, style: style)
                    .modifier(_label_Positioning(stateObject: stateObject,
                                                 localState: localState,
                                                 index: index,
                                                 count: labels.count))
            }
            .modifier(_Axis_Label_Size(localState: localState))
        }
        .onAppear { localState.orientation = orientation }
        .onChange(of: localState.widest) {
            stateObject.updateLayoutElement(with: ChartStateObject.Model(element: .leadingLabels, value: $0 + style.padding))
            
        }
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
    
    @ObservedObject var localState: YAxisLabelsLayoutModel
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
                            switch localState.orientation {
                            case .vertical:
                                value = geo.frame(in: .local).width
                            case .horizontal:
                                value = geo.frame(in: .local).height
                            }
                            localState.update(with: YAxisLabelsLayoutModel.Model(id: index, value: value))
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

    @ObservedObject var stateObject: ChartStateObject
    @ObservedObject var localState: YAxisLabelsLayoutModel
    let index: Int
    let count: Int

    func body(content: Content) -> some View {
        switch localState.orientation {
        case .vertical:
            content
                .frame(width: localState.widest,
                       height: divide(stateObject.chartSize.height, count))
                .position(x: localState.widest / 2,
                          y: CGFloat(index) * divide(stateObject.chartSize.height, count-1))
        case .horizontal:
            content
                .frame(width: divide(stateObject.chartSize.width, count),
                       height: localState.widest)
                .position(x: (CGFloat(index) * divide(stateObject.chartSize.width, count-1)),
                          y: localState.widest / 2)
        }
    }
}

fileprivate struct _Axis_Label_Size: ViewModifier {

    @ObservedObject var localState: YAxisLabelsLayoutModel

    func body(content: Content) -> some View {
        switch localState.orientation {
        case .vertical:
            content
                .frame(width: localState.widest)
        case .horizontal:
            content
                .frame(height: localState.widest)
        }
    }
}
