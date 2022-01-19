//
//  DSL.swift
//  
//
//  Created by Will Dale on 18/01/2022.
//

import SwiftUI
import ChartMath

//Chart(chartData: data) {
//    ZStack {
//        TestGrid<LineChartData>(orientation: .vertical, style: .standard)
//        TestGrid<LineChartData>(orientation: .horizontal, style: .standard)
//
//        TestLineChart()
//            .pointMarkers(chartData: data)
//            .touch(chartData: data)
//            .border(width: 1, edges: [.trailing, .bottom], color: .primary)
////                    .chartBorder(chartData: data, side: [.trailing, .top], style: .primary)
//    }
//    .padding()
//}

// -----

//@resultBuilder
//struct ChartBuilder {
//    static func buildBlock<T: BinaryInteger>(_ components: T...) -> T {
//        var result: T = 0
//        components.forEach { result += $0 }
//        return result
//    }
//}
//
//func chartBuilder<T: View>(@ChartBuilder content: () -> T) -> T {
//    return content()
//}

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

public struct HGrid: Shape {
    private let numberOfLines: UInt
    private let ignoreEdges: Bool
    
    public init(
        numberOfLines: UInt,
        ignoreEdges: Bool = false
    ) {
        self.numberOfLines = numberOfLines
        self.ignoreEdges = ignoreEdges
    }
    
    public func path(in rect: CGRect) -> Path {
        if numberOfLines == 0 { return Path() }
        if !ignoreEdges && numberOfLines == 1 ||
           ignoreEdges && 1...3 ~= numberOfLines {
            let pointOne = CGPoint(x: rect.minX, y: rect.midY)
            let pointTwo = CGPoint(x: rect.maxX, y: rect.midY)
            var path = Path()
            path.move(to: pointOne)
            path.addLine(to: pointTwo)
            return path
        } else if numberOfLines == 2 {
            let bottomPointOne = CGPoint(x: rect.minX, y: rect.maxY)
            let bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
            let topPointOne = CGPoint(x: rect.minX, y: rect.minY)
            let topPointTwo = CGPoint(x: rect.maxX, y: rect.minY)
            var path = Path()
            path.move(to: bottomPointOne)
            path.addLine(to: bottomPointTwo)
            path.move(to: topPointOne)
            path.addLine(to: topPointTwo)
            return path
        } else {
            let range = ignoreEdges ? 1..<numberOfLines-1 : 0..<numberOfLines
            let sectionSize = divide(rect.height, numberOfLines-1)
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
}

public struct VGrid: Shape {
    private let numberOfLines: UInt
    private let ignoreEdges: Bool
    
    public init(
        numberOfLines: UInt,
        ignoreEdges: Bool = false
    ) {
        self.numberOfLines = numberOfLines
        self.ignoreEdges = ignoreEdges
    }
    
    public func path(in rect: CGRect) -> Path {
        if numberOfLines == 0 { return Path() }
        if !ignoreEdges && numberOfLines == 1 ||
           ignoreEdges && 1...3 ~= numberOfLines {
            let pointOne = CGPoint(x: rect.midX, y: rect.minY)
            let pointTwo = CGPoint(x: rect.midX, y: rect.maxY)
            var path = Path()
            path.move(to: pointOne)
            path.addLine(to: pointTwo)
            return path
        } else if numberOfLines == 2 {
            let bottomPointOne = CGPoint(x: rect.maxX, y: rect.minY)
            let bottomPointTwo = CGPoint(x: rect.maxX, y: rect.maxY)
            let topPointOne = CGPoint(x: rect.minX, y: rect.minY)
            let topPointTwo = CGPoint(x: rect.minX, y: rect.maxY)
            var path = Path()
            path.move(to: bottomPointOne)
            path.addLine(to: bottomPointTwo)
            path.move(to: topPointOne)
            path.addLine(to: topPointTwo)
            return path
        } else {
            let range = ignoreEdges ? 1..<numberOfLines-1 : 0..<numberOfLines
            let sectionSize = divide(rect.width, numberOfLines-1)
            var path = Path()
            for index in range {
                let x = CGFloat(index) * sectionSize
                let pointOne = CGPoint(x: x, y: rect.minY)
                let pointTwo = CGPoint(x: x, y: rect.maxY)
                path.move(to: pointOne)
                path.addLine(to: pointTwo)
            }
            return path
        }
    }
}

final class YAxisModel: ObservableObject {
    @Published var widths = Set<Model>()
    @Published var widest: CGFloat = 0
    
    internal func update(with newItem: Model) {
        if let oldItem = widths.first(where: { $0.id == newItem.id }) {
            widths.remove(oldItem)
            widths.insert(newItem)
            print("Updated")
        } else {
            widths.insert(newItem)
            print("Added: \(newItem)")
        }
        widest = widths.map(\.value).max() ?? 0
        print("widest: \(widest)")
    }
    
    struct Model: Hashable {
        let id: Int
        let value: CGFloat
    }
}

// MARK: - TestYAxisLabels
public struct TestYAxisLabels<ChartData>: View
where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper & ObservableObject {
    
    @EnvironmentObject private var chartData: ChartData
    @ObservedObject private var state = YAxisModel()
    
    public var data: YAxisLabelStyle.Data
    public var style: YAxisLabelStyle
    
    public init(
        data: YAxisLabelStyle.Data,
        style: YAxisLabelStyle
    ) {
        self.data = data
        self.style = style
    }
    
    public var body: some View {
        ZStack {
            Labels_SubView(chartData: chartData, state: state, labels: labels, style: style)
        }
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
            return ([firstLabel] + otherLabels)
        case .custom(let labels):
            return labels
        }
    }
}

fileprivate struct Labels_SubView<ChartData>: View
where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper & ObservableObject {
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var state: YAxisModel
    
    var labels: [String]
    public var style: YAxisLabelStyle
    
    public init(
        chartData: ChartData,
        state: YAxisModel,
        labels: [String],
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.state = state
        self.labels = labels
        self.style = style
    }
        
    public var body: some View {
        ForEach(labels.indices, id: \.self) { index in
            _Label_Cell(chartData: chartData, state: state, label: labels[index], index: index, count: labels.count, style: style)
                .modifier(_label_Positioning(chartData: chartData, state: state, style: style, index: index, count: labels.count, frame: chartData.chartSize))
        }
        .frame(width: state.widest)
    }
}

fileprivate struct _Label_Cell<ChartData>: View
where ChartData: CTChartData & ViewDataProtocol & AxisY & DataHelper & ObservableObject {
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var state: YAxisModel
    
    var label: String
    var index: Int
    var count: Int
    var style: YAxisLabelStyle
    
    init(
        chartData: ChartData,
        state: YAxisModel,
        label: String,
        index: Int,
        count: Int,
        style: YAxisLabelStyle
    ) {
        self.chartData = chartData
        self.state = state
        self.label = label
        self.index = index
        self.count = count
        self.style = style
    }
    
    @State private var bounds: CGSize = .zero
    
    var body: some View {
        Text(LocalizedStringKey(label))
            .font(style.font)
            .foregroundColor(style.colour)
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear(perform: {
                            state.update(with: YAxisModel.Model(id: index, value: geo.frame(in: .local).width))
                        })
//                        .onChange(of: geo.frame(in: .local)) { newValue in
//                            state.update(with: YAxisModel.Model(id: index, value: newValue.width))
//                        }
                }
            )
            .fixedSize()
            .accessibilityLabel(LocalizedStringKey("Y-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}

// MARK: _label_Positioning
fileprivate struct _label_Positioning<ChartData>: ViewModifier where ChartData: CTChartData & ViewDataProtocol & AxisY {
    
    @ObservedObject private var chartData: ChartData
    @ObservedObject private var state: YAxisModel
    private var style: YAxisLabelStyle
    private var index: Int
    private var count: Int
    private var frame: CGRect
    
    internal init(
        chartData: ChartData,
        state: YAxisModel,
        style: YAxisLabelStyle,
        index: Int,
        count: Int,
        frame: CGRect
    ) {
        self.chartData = chartData
        self.state = state
        self.style = style
        self.index = index
        self.count = count
        self.frame = frame
    }
    
    func body(content: Content) -> some View {
        content
            .frame(width: state.widest,
                   height: chartData.yAxisSectionSizing(count: count, size: frame.height))
            .position(x: state.widest / 2,
                      y: chartData.yAxisLabelOffSet(index: index,
                                                    size: frame.height,
                                                    count: count))
    }
}

// MARK: - EdgeBorder
struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

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
    public func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}



// MARK: NO
public struct TestGrid: View {
    
    private var style: GridStyle
    private var orientation: Orientation
    
    public init(
        orientation: Orientation,
        style: GridStyle
    ) {
        self.style = style
        self.orientation = orientation
    }
    
    public var body: some View {
        switch orientation {
        case .vertical:
            HStack {
                ForEach((0...style.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        TestVerticalGridView(style: style)
                        Spacer()
                            .frame(minWidth: 0, maxWidth: 500)
                    }
                }
                TestVerticalGridView(style: style)
            }
        case .horizontal:
            VStack {
                ForEach((0...style.numberOfLines-1), id: \.self) { index in
                    if index != 0 {
                        TestHorizontalGridView(style: style)
                        Spacer()
                            .frame(minHeight: 0, maxHeight: 500)
                    }
                }
                TestHorizontalGridView(style: style)
            }
        }
    }
    
    public enum Orientation {
        case horizontal, vertical
    }
}

internal struct TestVerticalGridView: View {
    
    private var style: GridStyle
    @State private var startAnimation: Bool = false
    
    internal init(style: GridStyle) {
        self.style = style
    }
    
    var body: some View {
        VerticalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(style.lineColour,
                    style: StrokeStyle(lineWidth: style.lineWidth,
                                       dash: style.dash,
                                       dashPhase: style.dashPhase))
            .frame(width: style.lineWidth)
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
    }
}

internal struct TestHorizontalGridView: View {
    
    private var style: GridStyle
    @State private var startAnimation: Bool = false
    
    internal init(style: GridStyle) {
        self.style = style
    }
    
    var body: some View {
        HorizontalGridShape()
            .trim(to: startAnimation ? 1 : 0)
            .stroke(style.lineColour,
                    style: StrokeStyle(lineWidth: style.lineWidth,
                                       dash: style.dash,
                                       dashPhase: style.dashPhase))
            .frame(height: style.lineWidth)
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
    }
}
