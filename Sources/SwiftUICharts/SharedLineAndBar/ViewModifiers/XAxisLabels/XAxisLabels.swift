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
    public func xAxisLabels<ChartData: CTChartData>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        labels: [String],
        positions: Set<HorizontalEdge>,
        style: XAxisLabelStyle = .standard
    ) -> some View {
        self.modifier(
            _XAxisLabelsModifier_Vertical(
                chartData: chartData,
                stateObject: stateObject,
                labels: labels,
                positions: Array(positions),
                style: style
            )
        )
    }
    
    /// Labels for the X axis.
    ///
    /// For horizontal charts
    public func xAxisLabels<ChartData: CTChartData>(
        chartData: ChartData,
        stateObject: ChartStateObject,
        labels: [String],
        positions: Set<VerticalEdge>,
        style: XAxisLabelStyle = .standard
    ) -> some View {
        self.modifier(
            _XAxisLabelsModifier_Horizontal(
                chartData: chartData,
                stateObject: stateObject,
                labels: labels,
                positions: Array(positions),
                style: style
            )
        )
    }
}

// MARK: - AxisOrientation
fileprivate struct _XAxisLabelsModifier_Vertical<ChartData: CTChartData>: ViewModifier {
    
    let chartData: ChartData
    var stateObject: ChartStateObject
    let labels: [String]
    let positions: [HorizontalEdge]
    let style: XAxisLabelStyle
        
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .leading:
                HStack(spacing: style.padding) {
                    XAxisLabels(chartData: chartData, stateObject: stateObject, labels: labels, style: style, orientation: .horizontal)
                    content
                }
            case .trailing:
                HStack(spacing: style.padding) {
                    content
                    XAxisLabels(chartData: chartData, stateObject: stateObject, labels: labels, style: style, orientation: .horizontal)
                }
            }
        }
    }
}

fileprivate struct _XAxisLabelsModifier_Horizontal<ChartData: CTChartData>: ViewModifier {

    let chartData: ChartData
    var stateObject: ChartStateObject
    let labels: [String]
    let positions: [VerticalEdge]
    let style: XAxisLabelStyle
    
    func body(content: Content) -> some View {
        ForEach(positions) { position in
            switch position {
            case .bottom:
                VStack(spacing: style.padding) {
                    content
                    XAxisLabels(chartData: chartData, stateObject: stateObject, labels: labels, style: style, orientation: .vertical)
                }
            case .top:
                VStack(spacing: style.padding) {
                    XAxisLabels(chartData: chartData, stateObject: stateObject, labels: labels, style: style, orientation: .vertical)
                    content
                }
            }
        }
    }
}

// MARK: - View
public struct XAxisLabels<ChartData: CTChartData>: View {
    
    let chartData: ChartData
    @StateObject private var localState = XAxisLabelsLayoutModel()
    let stateObject: ChartStateObject
    
    let labels: [String]
    let style: XAxisLabelStyle
    
    let orientation: XAxisLabelStyle.AxisOrientation
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _label_Cell(localState: localState, label: labels[index], style: style, index: index)
                    .modifier(
                        _label_Positioning(
                            chartData: chartData,
                            localState: localState,
                            stateObject: stateObject,
                            index: index,
                            count: labels.count,
                            minLabel: localState.minWidth,
                            padding: localState.maxWidth,
                            inBounds: style.inBounds
                        )
                    )
            }
            .modifier(_Axis_Label_Size(localState: localState))
        }
        .onAppear {
            localState.orientation = orientation
            localState.isRotated = style.rotation.degrees != 0 || style.rotation.radians != 0
        }
    }
}

// MARK: Cell
fileprivate struct _label_Cell: View {
    
    var localState: XAxisLabelsLayoutModel
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
                            switch localState.orientation {
                            case .vertical:
                                width = geo.frame(in: .local).width
                                height = geo.frame(in: .local).height
                            case .horizontal:
                                width = geo.frame(in: .local).height
                                height = geo.frame(in: .local).width
                            }
                            localState.update(with: XAxisLabelsLayoutModel.Model(id: index, width: width, height: height))
                        }
                }
            )
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: - ViewModifiers
fileprivate struct _label_Positioning<ChartData: CTChartData>: ViewModifier {
    
    let chartData: ChartData
    @ObservedObject var localState: XAxisLabelsLayoutModel
    @ObservedObject var stateObject: ChartStateObject
    let index: Int
    let count: Int
    let minLabel: CGFloat
    let padding: CGFloat
    let inBounds: Bool
    
    func body(content: Content) -> some View {
        switch localState.orientation {
        case .vertical:
            content
                .frame(
                    width: xAxisSectionSizing(
                        chart: chartData.chartName,
                        count: count,
                        size: stateObject.chartSize.size.width,
                        minLabel: localState.minWidth,
                        padding: inBounds ? localState.maxWidth : 0,
                        spacing: chartData.spacing
                    ),
                    height: localState.isRotated ? localState.maxWidth : localState.maxHeight
                )
                .position(
                    x: xAxisLabelOffSet(
                        chart: chartData.chartName,
                        index: index,
                        count: count,
                        size: stateObject.chartSize.size.width,
                        minLabel: localState.minWidth,
                        padding: inBounds ? localState.width(for: index) : 0,
                        spacing: chartData.spacing
                    ),
                    y: localState.isRotated ? localState.width(for: index) / 2 : localState.maxHeight / 2
                )
        case .horizontal:
            content
                .frame(width: localState.maxWidth,
                       height: divide(stateObject.chartSize.size.height, count))
                .position(x: localState.maxWidth / 2,
                          y: (CGFloat(index) * divide(stateObject.chartSize.size.height, count-1)))
        }
    }
    
    // MARK: - Layout
    internal func xAxisSectionSizing(
        chart: ChartName,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat,
        spacing: CGFloat
    ) -> CGFloat {
        switch chart {
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
            let spaceSection = spacing * CGFloat(count - 1)
            let compensation = divide(spaceSection, count)
            let section = superXSection - compensation
            return section > 0 ? section : 0
            
        default:
            return .zero
        }
    }
    
    internal func xAxisLabelOffSet(
        chart: ChartName,
        index: Int,
        count: Int,
        size: CGFloat,
        minLabel: CGFloat,
        padding: CGFloat,
        spacing: CGFloat
    ) -> CGFloat {
        switch chart {
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
            let offSet = xAxisSectionSizing(chart: chart, count: count, size: size, minLabel: minLabel, padding: padding, spacing: spacing) / 2
            let pad = padding / 2
            return value + offSet + pad
            
        case .groupedBar:
            let superXSection = divide(size - padding, count)
            let compensation = ((spacing * CGFloat(count - 1)) / CGFloat(count))
            let section = (CGFloat(index) * superXSection) + ((CGFloat(index) * compensation) / CGFloat(count))
            let offSet = xAxisSectionSizing(chart: chart, count: count, size: size, minLabel: minLabel, padding: padding, spacing: spacing) / 2
            let pad = padding / 2
            return section + offSet + pad
        default:
            return .zero
        }
    }
}

fileprivate struct _Axis_Label_Size: ViewModifier {
    
    @ObservedObject var localState: XAxisLabelsLayoutModel
    
    func body(content: Content) -> some View {
        switch localState.orientation {
        case .vertical:
            content
                .frame(height: localState.maxHeight)
        case .horizontal:
            content
                .frame(width: localState.maxWidth)
        }
    }
}
