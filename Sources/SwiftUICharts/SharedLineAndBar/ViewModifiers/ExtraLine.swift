//
//  ExtraLine.swift
//  
//
//  Created by Will Dale on 08/05/2021.
//

import SwiftUI

// MARK: - View
internal struct ExtraLine<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    
    init(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping ()->([ExtraLineDataPoint]),
        style: @escaping ()->(ExtraLineStyle)
    ) {
        self.chartData = chartData
        self.chartData.extraLineData = ExtraLineData(legendTitle: legendTitle,
                                                     dataPoints: datapoints,
                                                     style: style)
        
        self.lineLegendSetup()
    }
    
    @State private var startAnimation: Bool = false
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                ZStack {
                    if chartData.extraLineData.style.lineColour.colourType == .colour,
                       let colour = chartData.extraLineData.style.lineColour.colour
                    {
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(colour, style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(colour, style: StrokeStyle(lineWidth: 3))
                            })
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    } else if chartData.extraLineData.style.lineColour.colourType == .gradientColour,
                              let colours = chartData.extraLineData.style.lineColour.colours,
                              let startPoint = chartData.extraLineData.style.lineColour.startPoint,
                              let endPoint = chartData.extraLineData.style.lineColour.endPoint
                    {
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(LinearGradient(gradient: Gradient(colors: colours),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            })
                            
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    } else if chartData.extraLineData.style.lineColour.colourType == .gradientStops,
                              let stops = chartData.extraLineData.style.lineColour.stops,
                              let startPoint = chartData.extraLineData.style.lineColour.startPoint,
                              let endPoint = chartData.extraLineData.style.lineColour.endPoint
                    {
                        let stops = GradientStop.convertToGradientStopsArray(stops: stops)
                        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints.map(\.value),
                                       lineType: chartData.extraLineData.style.lineType,
                                       lineSpacing: chartData.extraLineData.style.lineSpacing,
                                       range: chartData.extraLineData.range,
                                       minValue: chartData.extraLineData.minValue)
                            .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                                $0.trim(to: startAnimation ? 1 : 0)
                                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            }, else: {
                                $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                                    .stroke(LinearGradient(gradient: Gradient(stops: stops),
                                                           startPoint: startPoint,
                                                           endPoint: endPoint),
                                            style: StrokeStyle(lineWidth: 3))
                            })
                            .animateOnAppear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = true
                            }
                            .animateOnDisappear(using: chartData.chartStyle.globalAnimation) {
                                self.startAnimation = false
                            }
                            .zIndex(1)
                    }
                    content
                }
            } else { content }
        }
    }
    
    private func lineLegendSetup() {
        if self.chartData.extraLineData.style.lineColour.colourType == .colour,
           let colour = self.chartData.extraLineData.style.lineColour.colour
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(colour: colour),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientColour,
                  let colours = self.chartData.extraLineData.style.lineColour.colours
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(colours: colours,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientStops,
                  let stops = self.chartData.extraLineData.style.lineColour.stops
        {
            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
                                                legend: self.chartData.extraLineData.legendTitle,
                                                colour: ColourStyle(stops: stops,
                                                                    startPoint: .leading,
                                                                    endPoint: .trailing),
                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
                                                prioity: 3,
                                                chartType: .line))
        }
    }
}


// MARK: - View Extension
extension View {
    public func extraLine<T: CTLineBarChartDataProtocol>(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping ()->([ExtraLineDataPoint]),
        style: @escaping ()->(ExtraLineStyle)
    ) -> some View {
        self.modifier(ExtraLine<T>(chartData: chartData,
                                   legendTitle: legendTitle,
                                   datapoints: datapoints,
                                   style: style)
        )
    }
}



// MARK: - Data
public struct ExtraLineData: Identifiable {
    
    public let id: UUID = UUID()
    
    public var dataPoints: [ExtraLineDataPoint]
    public var style: ExtraLineStyle
    public var legendTitle: String
    
    public init(
        legendTitle: String,
        dataPoints: ()->([ExtraLineDataPoint]),
        style: ()->(ExtraLineStyle)
    ) {
        self.dataPoints = dataPoints()
        self.style = style()
        self.legendTitle = legendTitle
        
    }

    internal var range: Double {
        get {
            var _lowestValue: Double
            var _highestValue: Double
            
            switch self.style.baseline {
            case .minimumValue:
                _lowestValue = self.getMinValue()
            case .minimumWithMaximum(of: let value):
                _lowestValue = min(self.getMinValue(), value)
            case .zero:
                _lowestValue = 0
            }
            
            switch self.style.topLine {
            case .maximumValue:
                _highestValue = self.getMaxValue()
            case .maximum(of: let value):
                _highestValue = max(self.getMaxValue(), value)
            }
            
            return (_highestValue - _lowestValue) + 0.001
        }
    }
    internal var minValue: Double {
        get {
            switch self.style.baseline {
            case .minimumValue:
                return self.getMinValue()
            case .minimumWithMaximum(of: let value):
                return min(self.getMinValue(), value)
            case .zero:
                return 0
            }
        }
    }
    internal var maxValue: Double {
        get {
            switch self.style.topLine {
            case .maximumValue:
                return self.getMaxValue()
            case .maximum(of: let value):
                return max(self.getMaxValue(), value)
            }
        }
    }
    internal var average: Double {
        return self.getAverage()
    }
    
    
    internal func getMaxValue() -> Double {
        self.dataPoints
            .map(\.value)
            .max() ?? 0
    }
    internal func getMinValue() -> Double {
        self.dataPoints
            .map(\.value)
            .min() ?? 0
    }
    internal func getAverage() -> Double {
        self.dataPoints
            .map(\.value)
            .reduce(0, +)
            .divide(by: Double(self.dataPoints.count))
    }
}



// MARK: - Style
public struct ExtraLineStyle: Hashable {
    
    public var lineColour: ColourStyle
    public var lineType: LineType
    public var lineSpacing: SpacingType
    
    public var strokeStyle: Stroke
    
    public var yAxisTitle: String?
    public var yAxisNumberOfLabels: Int
    
    public var animationType: AnimationType
    
    public var baseline: Baseline
    public var topLine: Topline

    public init(
        lineColour: ColourStyle = ColourStyle(colour: .red),
        lineType: LineType = .curvedLine,
        lineSpacing: SpacingType = .line,
        
        strokeStyle: Stroke = Stroke(),
        
        yAxisTitle: String? = nil,
        yAxisNumberOfLabels: Int = 7,
        
        animationType: AnimationType = .draw,
        
        baseline: Baseline = .minimumValue,
        topLine: Topline = .maximumValue
    ) {
        self.lineColour = lineColour
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        self.strokeStyle = strokeStyle
        
        self.yAxisTitle = yAxisTitle
        self.yAxisNumberOfLabels = yAxisNumberOfLabels
        
        self.animationType = animationType
        
        self.baseline = baseline
        self.topLine = topLine
    }
    
    public enum AnimationType: Hashable {
        case draw
        case raise
    }
    
    public enum SpacingType: Hashable {
        case line
        case bar
    }
}

// MARK: - Data Point
public struct ExtraLineDataPoint: Hashable, Identifiable {
    
    public let id: UUID = UUID()
    public var value: Double

    public init(value: Double) {
        self.value = value
    }
}


// MARK: - Line
internal struct ExtraLineShape: Shape {
    
    private let dataPoints: [Double]
    private let lineType: LineType
    private let lineSpacing: ExtraLineStyle.SpacingType
    private let range: Double
    private let minValue: Double
    
    internal init(
        dataPoints: [Double],
        lineType: LineType,
        lineSpacing: ExtraLineStyle.SpacingType,
        range: Double,
        minValue: Double
    ) {
        self.dataPoints = dataPoints
        self.lineType = lineType
        self.lineSpacing = lineSpacing
        self.range = range
        self.minValue = minValue
    }
    
    internal func path(in rect: CGRect) -> Path {
        switch (lineType, lineSpacing) {
        case (.curvedLine, .line):
            return Path.extraLineCurved(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .line):
            return Path.extraLineStraight(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.curvedLine, .bar):
            return Path.extraLineCurvedBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        case (.line, .bar):
            return Path.extraLineStraightBarSpacing(rect: rect, dataPoints: dataPoints, minValue: minValue, range: range)
        }
    }
}

// MARK: - Paths
//
//
//
// MARK: - Line Spacing
extension Path {
    static func extraLineStraight(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0,
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            for index in 1 ..< dataPoints.count {
                let nextPoint = CGPoint(x: CGFloat(index) * x,
                                        y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    static func extraLineCurved(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count - 1)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPoint: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.move(to: firstPoint)
        
        var previousPoint = firstPoint
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: CGFloat(index) * x,
                                    y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        return path
    }
}

// MARK: - Bar Spacing
extension Path {
    static func extraLineStraightBarSpacing(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        if dataPoints.count >= 2 {
            let firstPoint = CGPoint(x: 0 + (x / 2),
                                     y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
            path.move(to: firstPoint)
            for index in 1 ..< dataPoints.count {
                let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                        y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
                path.addLine(to: nextPoint)
            }
        }
        return path
    }
    
    static func extraLineCurvedBarSpacing(
        rect: CGRect,
        dataPoints: [Double],
        minValue: Double,
        range: Double
    ) -> Path {
        let x: CGFloat = rect.width / CGFloat(dataPoints.count)
        let y: CGFloat = rect.height / CGFloat(range)
        var path = Path()
        
        let firstPointOne: CGPoint = CGPoint(x: 0,
                                          y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.move(to: firstPointOne)
        
        let firstPointTwo: CGPoint = CGPoint(x: 0 + (x / 2),
                                          y: (CGFloat(dataPoints[0] - minValue) * -y) + rect.height)
        path.addLine(to: firstPointTwo)
        
        var previousPoint = firstPointTwo
        
        for index in 1 ..< dataPoints.count {
            let nextPoint = CGPoint(x: (CGFloat(index) * x) + (x / 2),
                                    y: (CGFloat(dataPoints[index] - minValue) * -y) + rect.height)
            path.addCurve(to: nextPoint,
                          control1: CGPoint(x: previousPoint.x + (nextPoint.x - previousPoint.x) / 2,
                                            y: previousPoint.y),
                          control2: CGPoint(x: nextPoint.x - (nextPoint.x - previousPoint.x) / 2,
                                            y: nextPoint.y))
            previousPoint = nextPoint
        }
        
        let lastPoint: CGPoint = CGPoint(x: (CGFloat(dataPoints.count) * x),
                                         y: (CGFloat(dataPoints[dataPoints.count - 1] - minValue) * -y) + rect.height)
        path.addLine(to: lastPoint)
        
        return path
    }
}


// MARK: - CTLineBarChartDataProtocol
extension CTLineBarChartDataProtocol {
    
    
    internal var extraLabelsArray: [String] { self.generateExtraYLabels(self.viewData.yAxisSpecifier) }
    private func generateExtraYLabels(_ specifier: String) -> [String] {
        
        let dataRange: Double = self.extraLineData.range
        let minValue: Double = self.extraLineData.minValue
        let range: Double = dataRange / Double(self.extraLineData.style.yAxisNumberOfLabels-1)
        let firstLabel = [String(format: specifier, minValue)]
        let otherLabels = (1...self.extraLineData.style.yAxisNumberOfLabels-1).map { String(format: specifier, minValue + range * Double($0)) }
        let labels = firstLabel + otherLabels
        return labels

    }
    public func getExtraYAxisLabels() -> some View {
        VStack {
            if self.chartStyle.xAxisLabelPosition == .top {
                Spacer()
                    .frame(height: yAxisPaddingHeight)
            }
            ForEach(self.extraLabelsArray.indices.reversed(), id: \.self) { i in
                Text(self.extraLabelsArray[i])
                    .font(self.chartStyle.yAxisLabelFont)
                    .foregroundColor(self.chartStyle.yAxisLabelColour)
                    .lineLimit(1)
                    .overlay(
                        GeometryReader { geo in
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .onAppear {
                                    self.viewData.yAxisLabelWidth.append(geo.size.width)
                                }
                        }
                    )
                    .accessibilityLabel(Text("Y Axis Label"))
                    .accessibilityValue(Text(self.extraLabelsArray[i]))
                if i != 0 {
                    Spacer()
                        .frame(minHeight: 0, maxHeight: 500)
                }
            }
            if self.chartStyle.xAxisLabelPosition == .bottom {
                Spacer()
                    .frame(height: yAxisPaddingHeight)
            }
        }
        .ifElse(self.chartStyle.xAxisLabelPosition == .bottom, if: {
            $0.padding(.top, -8)
        }, else: {
            $0.padding(.bottom, -8)
        })
    }
    public func getExtraYAxisTitle(colour: AxisColour) -> some View {
        Group {
            if let title = self.extraLineData.style.yAxisTitle {
                VStack {
                    if self.chartStyle.xAxisLabelPosition == .top {
                        Spacer()
                            .frame(height: yAxisPaddingHeight)
                    }
                    VStack {
                        Text(title)
                            .font(self.chartStyle.yAxisTitleFont)
                            .foregroundColor(self.chartStyle.yAxisTitleColour)
                            .background(
                                GeometryReader { geo in
                                    Rectangle()
                                        .foregroundColor(Color.clear)
                                        .onAppear {
                                            self.viewData.extraYAxisTitleWidth = geo.size.height + 10 // 10 to add padding
                                            self.viewData.extraYAxisTitleHeight = geo.size.width
                                        }
                                }
                            )
                            .rotationEffect(Angle.init(degrees: -90), anchor: .center)
                            .fixedSize()
                            .frame(width: self.viewData.extraYAxisTitleWidth)
                        Group {
                            switch colour {
                            case .none:
                                EmptyView()
                            case .style(let size):
                                self.getAxisColourAsCircle(customColour: self.extraLineData.style.lineColour, width: size)
                            case .custom(let colour, let size):
                                self.getAxisColourAsCircle(customColour: colour, width: size)
                            }
                        }
                        .offset(x: 0, y: self.viewData.extraYAxisTitleHeight / 2)
                    }
                    if self.chartStyle.xAxisLabelPosition == .bottom {
                        Spacer()
                            .frame(height: yAxisPaddingHeight)
                    }
                }
            }
        }
    }
}

public enum AxisColour {
    case none
    case style(size: CGFloat)
    case custom(colour: ColourStyle, size: CGFloat)
}

// MARK: - ExtraYAxisLabels
internal struct ExtraYAxisLabels<T>: ViewModifier where T: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: T
    private let specifier: String
    private let colourIndicator: AxisColour
    
    internal init(
        chartData: T,
        specifier: String,
        colourIndicator: AxisColour
    ) {
        self.chartData = chartData
        self.specifier = specifier
        self.colourIndicator = colourIndicator
        chartData.viewData.hasYAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                switch chartData.chartStyle.yAxisLabelPosition {
                case .leading:
                    HStack(spacing: 0) {
                        content
                        chartData.getExtraYAxisLabels().padding(.leading, 4)
                        chartData.getExtraYAxisTitle(colour: colourIndicator)
                    }
                case .trailing:
                    HStack(spacing: 0) {
                        chartData.getExtraYAxisTitle(colour: colourIndicator)
                        chartData.getExtraYAxisLabels().padding(.trailing, 4)
                        content
                    }
                }
            } else { content }
        }
    }
}

extension View {
    public func extraYAxisLabels<T: CTLineBarChartDataProtocol>(
        chartData: T,
        specifier: String = "%.0f",
        colourIndicator: AxisColour = .none
    ) -> some View {
        self.modifier(ExtraYAxisLabels(chartData: chartData, specifier: specifier, colourIndicator: colourIndicator))
    }
}
