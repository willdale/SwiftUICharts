//
//  DSL.swift
//  
//
//  Created by Will Dale on 18/01/2022.
//

import SwiftUI
import ChartMath

public struct Chart<Content, ChartData>: View where ChartData: CTChartData,
                                                    Content: View {
    
    @ObservedObject private var chartData: ChartData
    let content: Content
    
    /// Initialises a line chart view.
    /// - Parameter chartData: Must be LineChartData model.
    public init(
        chartData: ChartData,
        @ViewBuilder content: () -> Content
    ) {
        self.chartData = chartData
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding()
            .drawingGroup()
            .environmentObject(chartData)
    }
}

// MARK: TestLineChart
public struct TestLineChart<ChartData>: View where ChartData: LineChartData {
    
    @EnvironmentObject private var chartData: ChartData
    
    public init() {}
    
    public var body: some View {
        ZStack {
            chartData.getAccessibility()
            LineSubView(chartData: chartData,
                        colour: chartData.dataSets.style.lineColour)
                .modifier(SizeModifier(chartData: chartData))
        }
    }
}

// MARK: Grid
public struct Grid: Shape {
    
    public var orientation: Orientation
    public var numberOfLines: UInt
    public var ignoreEdges: Bool
    
    public init(
        orientation: Orientation,
        numberOfLines: UInt,
        ignoreEdges: Bool = false
    ) {
        self.orientation = orientation
        self.numberOfLines = numberOfLines
        self.ignoreEdges = ignoreEdges
    }
    
    public func path(in rect: CGRect) -> Path {
        if numberOfLines == 0 { return Path() }
        if !ignoreEdges && numberOfLines == 1 ||
           ignoreEdges && 1...3 ~= numberOfLines {
            let pointOne: CGPoint
            let pointTwo: CGPoint
            switch orientation {
            case .horizontal:
                pointOne = CGPoint(x: rect.minX, y: rect.midY)
                pointTwo = CGPoint(x: rect.maxX, y: rect.midY)
            case .vertical:
                pointOne = CGPoint(x: rect.midX, y: rect.minY)
                pointTwo = CGPoint(x: rect.midX, y: rect.maxY)
            }
            
            var path = Path()
            path.move(to: pointOne)
            path.addLine(to: pointTwo)
            return path
        } else if numberOfLines == 2 {
            let bottomPointOne: CGPoint
            let bottomPointTwo: CGPoint
            let topPointOne: CGPoint
            let topPointTwo: CGPoint
            switch orientation {
            case .horizontal:
                bottomPointOne = CGPoint(x: rect.minX, y: rect.maxY)
                bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
                topPointOne = CGPoint(x: rect.minX, y: rect.minY)
                topPointTwo = CGPoint(x: rect.maxX, y: rect.minY)
            case .vertical:
                bottomPointOne = CGPoint(x: rect.maxX, y: rect.minY)
                bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
                topPointOne = CGPoint(x: rect.minX, y: rect.minY)
                topPointTwo = CGPoint(x: rect.minX, y: rect.maxY)
            }

            var path = Path()
            path.move(to: bottomPointOne)
            path.addLine(to: bottomPointTwo)
            path.move(to: topPointOne)
            path.addLine(to: topPointTwo)
            return path
        } else {
            let range = ignoreEdges ? 1..<numberOfLines-1 : 0..<numberOfLines
            let sectionSize: CGFloat
            switch orientation {
            case .horizontal:
                sectionSize = divide(rect.height, numberOfLines-1)
            case .vertical:
                sectionSize = divide(rect.width, numberOfLines-1)
            }
            
            var path = Path()
            for index in range {
                let y = CGFloat(index) * sectionSize
                let pointOne = CGPoint(x: rect.minX, y: y)
                let pointTwo = CGPoint(x: rect.maxX, y: y)
                path.move(to: pointOne)
                path.addLine(to: pointTwo)
            }
            return path
        }
    }
    
    public enum Orientation {
        case horizontal
        case vertical
    }
}

// MARK: - YAxisLabels
internal final class YAxisLabelsLayoutModel: ObservableObject  {
        
    @Published internal var widths = Set<Model>()
    @Published internal var widest: CGFloat = 0
    
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


public struct TestYAxisLabels<ChartData>: View where ChartData: CTChartData & DataHelper {

    @ObservedObject private var chartData: ChartData
    @StateObject private var state = YAxisLabelsLayoutModel()
    
    internal let data: YAxisLabelStyle.Data
    internal let style: YAxisLabelStyle
    
    public init(
        _ chartData: ChartData,
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.style = style
    }
    
    public var body: some View {
        ZStack {
            ForEach(labels.indices, id: \.self) { index in
                _Label_Cell(state: state, label: labels[index], index: index, count: labels.count, style: style)
                    .frame(width: state.widest,
                           height: divide(chartData.chartSize.height, labels.count))
                    .position(x: state.widest / 2,
                              y: CGFloat(index) * divide(chartData.chartSize.height, labels.count-1))
            }
            .frame(width: state.widest)
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
            return ([firstLabel] + otherLabels)
        case .custom(let labels):
            return labels
        }
    }
}

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
                            state.update(with: YAxisLabelsLayoutModel.Model(id: index, value: geo.frame(in: .local).width))
                        }
                }
            )
            .fixedSize()
            .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: - XAxisLabels
public struct TestXAxisLabels<ChartData>: View where ChartData: CTChartData & AxisX & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var data: XAxisLabelStyle.Data
    private var style: XAxisLabelStyle
    
    public init(
        _ chartData: ChartData,
        data: XAxisLabelStyle.Data,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.style = style
    }
    
    public var body: some View {
        ZStack {
            _Labels_SubView(chartData: chartData,
                            data: data,
                            style: style)
        }
        .frame(height: chartData.xAxisViewData.xAxisLabelHeights.max())
    }
}

// MARK: _Labels_Data_Source
fileprivate struct _Labels_SubView<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol & AxisX {
    
    @ObservedObject private var chartData: ChartData
    private var data: XAxisLabelStyle.Data
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        data: XAxisLabelStyle.Data,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.data = data
        self.style = style
    }
    
    var body: some View {
        switch data {
        case .datapoints:
            ForEach(chartData.dataSets.dataLabels.indices, id: \.self) { index in
                TestRotatedText(chartData: chartData, label: chartData.dataSets.dataLabels[index], style: style)
                    .frame(width: chartData.xAxisSectionSizing(count: chartData.dataSets.dataWidth, size: chartData.chartSize.width),
                           height: chartData.xAxisViewData.xAxisLabelHeights.max())
                    .position(x: chartData.xAxisLabelOffSet(index: index, size: chartData.chartSize.width, count: chartData.dataSets.dataWidth),
                              y: (chartData.xAxisViewData.xAxisLabelHeights.max() ?? 0) / 2)
            }
        case .custom(let labels):
            HStack(spacing: 0) {
                ForEach(labels.indices, id: \.self) { index in
                    TestRotatedText(chartData: chartData, label: labels[index], style: style)
                    if index != labels.count - 1 {
                        Spacer().frame(minWidth: 0, maxWidth: 500)
                    }
                }
            }
        }
    }
}

// MARK: - RotatedText
internal struct TestRotatedText<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        label: String,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.label = label
        self.style = style
    }
    
    @State private var finalFrame: CGRect = .zero
    
    internal var body: some View {
        Text(LocalizedStringKey(label))
            .font(style.font)
            .foregroundColor(style.fontColour)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            finalFrame = geo.frame(in: .local)
                            chartData.xAxisViewData.xAxisLabelHeights.append(geo.frame(in: .local).width)
                            if style.rotation == .degrees(0) || style.rotation == .radians(0) {
                                chartData.xAxisViewData.xAxisLabelWidths.append(geo.frame(in: .local).width)
                            } else {
                                chartData.xAxisViewData.xAxisLabelWidths.append(geo.frame(in: .local).height)
                            }
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(style.rotation, anchor: .center)
            .frame(width: style.rotation == .degrees(0) || style.rotation == .radians(0) ? finalFrame.width : finalFrame.height,
                   height: style.rotation == .degrees(0) || style.rotation == .radians(0) ? finalFrame.height : finalFrame.width)
            
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}


// MARK: - EdgeBorder
struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: Set<Edge>

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    public func border(width: CGFloat, edges: Set<Edge>, color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}
