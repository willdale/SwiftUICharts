//
//  AxisDividers.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct AxisBorder<ChartData>: ViewModifier where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    private var border: ChartBorder
    
    internal init(
        chartData: ChartData,
        side: ChartBorder.Side,
        style: ChartBorder.Style
    ) {
        self.chartData = chartData
        self.border = ChartBorder(side: side, style: style)
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch border.side {
            case .top:
                ZStack(alignment: .top) {
                    HorizontalBorderView(chartData: chartData, style: border.style)
                    content
                }
            case .leading:
                ZStack(alignment: .leading) {
                    VerticalBorderView(chartData: chartData, style: border.style)
                    content
                }
            case .trailing:
                ZStack(alignment: .trailing) {
                    content
                    VerticalBorderView(chartData: chartData, style: border.style)
                }
            case .bottom:
                ZStack(alignment: .bottom) {
                    content
                    HorizontalBorderView(chartData: chartData, style: border.style)
                }
            }
        }
    }
}
// MARK: - Extension
extension View {
    public func axisBorder<ChartData>(
        chartData: ChartData,
        side: ChartBorder.Side,
        style: ChartBorder.Style
    ) -> some View
    where ChartData: CTChartData
    {
        self.modifier(AxisBorder(chartData: chartData, side: side, style: style))
    }
}

// MARK: - ChartBorder
public struct ChartBorder {
    public var side: Side
    public var style: Style
    
    public enum Side {
        case top
        case leading
        case trailing
        case bottom
    }
    
    public struct Style: Hashable {
        /// Line Colour
        public var lineColour: Color
        
        /// Line Width
        public var lineWidth: CGFloat
        
        /// Dash
        public var dash: [CGFloat]
        
        /// Dash Phase
        public var dashPhase: CGFloat
        
        /// Model for controlling the look of the Grid
        /// - Parameters:
        ///   - lineColour: Line Colour
        ///   - lineWidth: Line Width
        ///   - dash: Dash
        ///   - dashPhase: Dash Phase
        public init(
            lineColour: Color = Color(.gray).opacity(0.25),
            lineWidth: CGFloat = 1,
            dash: [CGFloat] = [],
            dashPhase: CGFloat = 0
        ) {
            self.lineColour = lineColour
            self.lineWidth = lineWidth
            self.dash = dash
            self.dashPhase = dashPhase
        }
    }
}

extension ChartBorder.Style {
    public static let white = ChartBorder.Style(lineColour: Color(.white))
    public static let lightGray = ChartBorder.Style(lineColour: Color(.gray).opacity(0.50))
    public static let gray = ChartBorder.Style(lineColour: Color(.gray))
    public static let black = ChartBorder.Style(lineColour: Color(.black))
    public static let primary = ChartBorder.Style(lineColour: Color.primary)
}

// MARK: - HorizontalBorderView
internal struct HorizontalBorderView<ChartData>: View where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    private var style: ChartBorder.Style
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        style: ChartBorder.Style
    ) {
        self.chartData = chartData
        self.style = style
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
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

// MARK: - VerticalBorderView
internal struct VerticalBorderView<ChartData>: View where ChartData: CTChartData {
    
    @ObservedObject private var chartData: ChartData
    private var style: ChartBorder.Style
    
    @State private var startAnimation: Bool
    
    internal init(
        chartData: ChartData,
        style: ChartBorder.Style
    ) {
        self.chartData = chartData
        self.style = style
        self._startAnimation = State<Bool>(initialValue: chartData.shouldAnimate ? false : true)
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
