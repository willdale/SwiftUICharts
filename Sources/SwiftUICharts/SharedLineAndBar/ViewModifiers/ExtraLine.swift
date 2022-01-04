//
//  ExtraLine.swift
//  
//
//  Created by Will Dale on 08/05/2021.
//

import SwiftUI

// MARK: - View
internal struct ExtraLine<T>: ViewModifier where T: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: T
    
    @State private var startAnimation: Bool
    
    init(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping ()->([ExtraLineDataPoint]),
        style: @escaping ()->(ExtraLineStyle)
    ) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)

        self.chartData.extraLineData = ExtraLineData(legendTitle: legendTitle,
                                                     dataPoints: datapoints,
                                                     style: style)
        self.lineLegendSetup()
    }
    
    internal func body(content: Content) -> some View {
        Group {
            ZStack {
                Group {
                    switch chartData.extraLineData.style.lineColour {
                    case let .colour(colour):
                        Group {
                            ColourExtraLineView(chartData: chartData, colour: colour)
                            PointsExtraLineView(chartData: chartData)
                        }
                    case let .gradient(colours, startPoint, endPoint):
                        Group {
                            ColoursExtraLineView(chartData: chartData, colours: colours, startPoint: startPoint, endPoint: endPoint)
                            PointsExtraLineView(chartData: chartData)
                        }
                    case let .gradientStops(stops, startPoint, endPoint):
                        Group {
                            StopsExtraLineView(chartData: chartData, stops: stops, startPoint: startPoint, endPoint: endPoint)
                            PointsExtraLineView(chartData: chartData)
                        }
                    }
                }
                content
            }
        }
    }
    
    private func lineLegendSetup() {
//        if self.chartData.extraLineData.style.lineColour.colourType == .colour,
//           let colour = self.chartData.extraLineData.style.lineColour.colour
//        {
//            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
//                                                legend: self.chartData.extraLineData.legendTitle,
//                                                colour: ColourStyle(colour: colour),
//                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
//                                                prioity: 3,
//                                                chartType: .line))
//        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientColour,
//                  let colours = self.chartData.extraLineData.style.lineColour.colours
//        {
//            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
//                                                legend: self.chartData.extraLineData.legendTitle,
//                                                colour: ColourStyle(colours: colours,
//                                                                    startPoint: .leading,
//                                                                    endPoint: .trailing),
//                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
//                                                prioity: 3,
//                                                chartType: .line))
//        } else if self.chartData.extraLineData.style.lineColour.colourType == .gradientStops,
//                  let stops = self.chartData.extraLineData.style.lineColour.stops
//        {
//            chartData.legends.append(LegendData(id: self.chartData.extraLineData.id,
//                                                legend: self.chartData.extraLineData.legendTitle,
//                                                colour: ColourStyle(stops: stops,
//                                                                    startPoint: .leading,
//                                                                    endPoint: .trailing),
//                                                strokeStyle: self.chartData.extraLineData.style.strokeStyle,
//                                                prioity: 3,
//                                                chartType: .line))
//        }
    }
}


// MARK: - View Extension
extension View {
    /**
     Adds an seperate line that is over-layed on top of a other chart.
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     - Parameters:
        - chartData: Data that conforms to CTLineBarChartDataProtocol.
        - legendTitle: Title of the extra line to display in the legends.
        - datapoints: Data point to create the line.
        - style: Styling data for the line.
     - Returns: The chart with an extra line stacked on top.
     */
    public func extraLine<T: CTChartData & ExtraLineProtocol>(
        chartData: T,
        legendTitle: String,
        datapoints: @escaping () -> ([ExtraLineDataPoint]),
        style: @escaping () -> (ExtraLineStyle)
    ) -> some View {
        self.modifier(ExtraLine<T>(chartData: chartData,
                                   legendTitle: legendTitle,
                                   datapoints: datapoints,
                                   style: style)
        )
    }
    
    /**
     Adds an seperate line that is over-layed on top of a other chart.
     
     - Requires:
     Chart Data to conform to CTLineBarChartDataProtocol.
     
     - Parameters:
        - chartData: Data that conforms to CTLineBarChartDataProtocol.
        - legendTitle: Title of the extra line to display in the legends.
        - datapoints: Data point to create the line.
        - style: Styling data for the line.
     - Returns: The chart with an extra line stacked on top.
     */
    public func extraLine<T: CTChartData & ExtraLineProtocol>(
        chartData: T,
        legendTitle: String,
        datapoints: @autoclosure @escaping () -> ([ExtraLineDataPoint]),
        style: @autoclosure @escaping () -> (ExtraLineStyle)
    ) -> some View {
        self.modifier(ExtraLine<T>(chartData: chartData,
                                   legendTitle: legendTitle,
                                   datapoints: datapoints,
                                   style: style)
        )
    }
}

// MARK: - Colour
internal struct ColourExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    let colour: Color
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        colour: Color
    ) {
        self.chartData = chartData
        self.colour = colour
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    var body: some View {
        
        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints,
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
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
            .zIndex(1)
    }
}

// MARK: - Colours
internal struct ColoursExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    let colours: [Color]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        colours: [Color],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.colours = colours
        self.startPoint = startPoint
        self.endPoint = endPoint
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    var body: some View {
        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints,
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
            
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
    }
}

// MARK: - Stops
internal struct StopsExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    let stops: [Gradient.Stop]
    let startPoint: UnitPoint
    let endPoint: UnitPoint
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        stops: [Gradient.Stop],
        startPoint: UnitPoint,
        endPoint: UnitPoint
    ) {
        self.chartData = chartData
        self.stops = stops
        self.startPoint = startPoint
        self.endPoint = endPoint
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    var body: some View {
        ExtraLineShape(dataPoints: chartData.extraLineData.dataPoints,
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
            .animateOnAppear(using: .linear) {
                self.startAnimation = true
            }
            .onDisappear {
                self.startAnimation = false
            }
            .zIndex(1)
    }
}

// MARK: - Points
internal struct PointsExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData
    ) {
        self.chartData = chartData
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        Group {
            switch chartData.extraLineData.style.pointStyle.pointType {
            case .filled:
                ForEach(chartData.extraLineData.dataPoints.indices, id: \.self) { index in
                    FilledDataPointExtraLineView(chartData: chartData,
                                                 dataPoint: chartData.extraLineData.dataPoints[index],
                                                 index: index)
                }
                
            case .outline:
                ForEach(chartData.extraLineData.dataPoints.indices, id: \.self) { index in
                    OutLineDataPointExtraLineView(chartData: chartData,
                                                  dataPoint: chartData.extraLineData.dataPoints[index],
                                                  index: index)
                }
                
            case .filledOutLine:
                ForEach(chartData.extraLineData.dataPoints.indices, id: \.self) { index in
                    FilledDataPointExtraLineView(chartData: chartData,
                                                 dataPoint: chartData.extraLineData.dataPoints[index],
                                                 index: index)
                        .background(Point(datapoint: chartData.extraLineData.dataPoints[index],
                                          index: index,
                                          minValue: chartData.extraLineData.minValue,
                                          range: chartData.extraLineData.range,
                                          datapointCount: chartData.extraLineData.dataPoints.count,
                                          pointSize: chartData.extraLineData.style.pointStyle.pointSize,
                                          pointStyle: chartData.extraLineData.style.pointStyle.pointShape)
                                        .foregroundColor(chartData.extraLineData.dataPoints[index].pointColour?.fill ?? chartData.extraLineData.style.pointStyle.fillColour)
                        )
                }
            }
        }
        .zIndex(1.0)
    }
}

// MARK: - Filled Data Point
internal struct FilledDataPointExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: ExtraLineDataPoint
    private let index: Int
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataPoint: ExtraLineDataPoint,
        index: Int
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.index = index
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        switch chartData.extraLineData.style.lineSpacing {
        case .line:
            Point(datapoint: dataPoint,
                  index: index,
                  minValue: chartData.extraLineData.minValue,
                  range: chartData.extraLineData.range,
                  datapointCount: chartData.extraLineData.dataPoints.count,
                  pointSize: chartData.extraLineData.style.pointStyle.pointSize,
                  pointStyle: chartData.extraLineData.style.pointStyle.pointShape)
                .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                    $0
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(dataPoint.pointColour?.fill ?? chartData.extraLineData.style.pointStyle.fillColour)
                }, else: {
                    $0
                        .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .fill(dataPoint.pointColour?.fill ?? chartData.extraLineData.style.pointStyle.fillColour)
                })
                .animateOnAppear(using: .linear) {
                    self.startAnimation = true
                }
                .onDisappear {
                    self.startAnimation = false
                }
        case .bar:
            PointBarSpcing(value: dataPoint.value,
                           index: index,
                           minValue: chartData.extraLineData.minValue,
                           range: chartData.extraLineData.range,
                           datapointCount: chartData.extraLineData.dataPoints.count,
                           pointSize: chartData.extraLineData.style.pointStyle.pointSize,
                           ignoreZero: false,
                           pointStyle: chartData.extraLineData.style.pointStyle.pointShape)
                .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                    $0
                        .trim(to: startAnimation ? 1 : 0)
                        .fill(dataPoint.pointColour?.fill ?? chartData.extraLineData.style.pointStyle.fillColour)
                }, else: {
                    $0
                        .scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .fill(dataPoint.pointColour?.fill ?? chartData.extraLineData.style.pointStyle.fillColour)
                })
                .animateOnAppear(using: .linear) {
                    self.startAnimation = true
                }
                .onDisappear {
                    self.startAnimation = false
                }
        }
    }
}

// MARK: - OutLine DataPoint
internal struct OutLineDataPointExtraLineView<ChartData>: View where ChartData: CTChartData & ExtraLineProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let dataPoint: ExtraLineDataPoint
    private let index: Int
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        dataPoint: ExtraLineDataPoint,
        index: Int
    ) {
        self.chartData = chartData
        self.dataPoint = dataPoint
        self.index = index
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
    }
    
    internal var body: some View {
        
        switch chartData.extraLineData.style.lineSpacing {
        case .line:
            Point(datapoint: dataPoint,
                  index: index,
                  minValue: chartData.extraLineData.minValue,
                  range: chartData.extraLineData.range,
                  datapointCount: chartData.extraLineData.dataPoints.count,
                  pointSize: chartData.extraLineData.style.pointStyle.pointSize,
                  pointStyle: chartData.extraLineData.style.pointStyle.pointShape)
                .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                    $0.trim(to: startAnimation ? 1 : 0)
                        .stroke(dataPoint.pointColour?.border ?? chartData.extraLineData.style.pointStyle.borderColour,
                                lineWidth: chartData.extraLineData.style.pointStyle.lineWidth)
                }, else: {
                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .stroke(dataPoint.pointColour?.border ?? chartData.extraLineData.style.pointStyle.borderColour,
                                lineWidth: chartData.extraLineData.style.pointStyle.lineWidth)
                })
                .animateOnAppear(using: .linear) {
                    self.startAnimation = true
                }
                .onDisappear {
                    self.startAnimation = false
                }
        case .bar:
            PointBarSpcing(value: dataPoint.value,
                           index: index,
                           minValue: chartData.extraLineData.minValue,
                           range: chartData.extraLineData.range,
                           datapointCount: chartData.extraLineData.dataPoints.count,
                           pointSize: chartData.extraLineData.style.pointStyle.pointSize,
                           ignoreZero: false,
                           pointStyle: chartData.extraLineData.style.pointStyle.pointShape)
                .ifElse(chartData.extraLineData.style.animationType == .draw, if: {
                    $0.trim(to: startAnimation ? 1 : 0)
                        .stroke(dataPoint.pointColour?.border ?? chartData.extraLineData.style.pointStyle.borderColour,
                                lineWidth: chartData.extraLineData.style.pointStyle.lineWidth)
                }, else: {
                    $0.scale(y: startAnimation ? 1 : 0, anchor: .bottom)
                        .stroke(dataPoint.pointColour?.border ?? chartData.extraLineData.style.pointStyle.borderColour,
                                lineWidth: chartData.extraLineData.style.pointStyle.lineWidth)
                })
                .animateOnAppear(using: .linear) {
                    self.startAnimation = true
                }
                .onDisappear {
                    self.startAnimation = false
                }
        }
    }
}

// MARK: - Bar Point 
/// Custom version of ``Point`` for Extra Line
/// when being used on a Bar Chart.
internal struct PointBarSpcing: Shape {
    
    private let value: Double
    private let index: Int
    private let minValue: Double
    private let range: Double
    private let datapointCount: Int
    private let pointSize: CGFloat
    private let ignoreZero: Bool
    private let pointStyle: PointShape
    
    internal init(
        value: Double,
        index: Int,
        minValue: Double,
        range: Double,
        datapointCount: Int,
        pointSize: CGFloat,
        ignoreZero: Bool,
        pointStyle: PointShape
    ) {
        self.value = value
        self.index = index
        self.minValue = minValue
        self.range = range
        self.datapointCount = datapointCount
        self.pointSize = pointSize
        self.ignoreZero = ignoreZero
        self.pointStyle = pointStyle
    }
    
    internal func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let x: CGFloat = rect.width / CGFloat(datapointCount)
        let y: CGFloat = rect.height / CGFloat(range)
        let offset: CGFloat = pointSize / CGFloat(2)
        
        let pointX: CGFloat = (CGFloat(index) * x) + (x / 2) - offset
        let pointY: CGFloat = ((CGFloat(value - minValue) * -y) + rect.height) - offset
        let point: CGRect = CGRect(x: pointX, y: pointY, width: pointSize, height: pointSize)
        if !ignoreZero {
            pointSwitch(&path, point)
        } else {
            if value != 0 {
                pointSwitch(&path, point)
            }
        }
        return path
    }
    
    /// Draws the points based on chosen parameters.
    /// - Parameters:
    ///   - path: Path to draw on.
    ///   - point: Position to draw the point.
    internal func pointSwitch(_ path: inout Path, _ point: CGRect) {
        switch pointStyle {
        case .circle:
            path.addEllipse(in: point)
        case .square:
            path.addRect(point)
        case .roundSquare:
            path.addRoundedRect(in: point, cornerSize: CGSize(width: 3, height: 3))
        }
    }
}
