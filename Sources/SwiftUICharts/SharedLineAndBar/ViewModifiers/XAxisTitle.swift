//
//  AxisTitle.swift
//  
//
//  Created by Will Dale on 03/01/2022.
//

import SwiftUI

public struct AxisTitleData {
    /// Which axis the label is on.
    public var position: Edge

    /// Font of the axis title.
    public var font: Font
    
    /// Colour of the x axis title.
    public var colour: Color
    
    
    public init(
        position: Edge,
        font: Font = .caption,
        colour: Color = .primary
    ) {
        self.position = position
        self.font = font
        self.colour = colour
    }
}

extension AxisTitleData {
    public static let top = AxisTitleData(position: .top, font: .caption, colour: .primary)
    public static let leading = AxisTitleData(position: .leading, font: .caption, colour: .primary)
    public static let trailing = AxisTitleData(position: .trailing, font: .caption, colour: .primary)
    public static let bottom = AxisTitleData(position: .bottom, font: .caption, colour: .primary)
}

internal struct AxisTitle<ChartData>: ViewModifier where ChartData: CTChartData & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var text: String
    private var style: AxisTitleData
    
    internal init(
        chartData: ChartData,
        text: String,
        style: AxisTitleData
    ) {
        self.chartData = chartData
        self.text = text
        self.style = style
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch style.position {
            case .top:
                VStack {
                    _XAxisTitle_View(chartData: chartData, text: text, style: style)
                    content
                }
            case .bottom:
                VStack {
                    content
                    _XAxisTitle_View(chartData: chartData, text: text, style: style)
                }
            case .leading:
                HStack {
                    _YAxisTitle_View(chartData: chartData, text: text, style: style)
                    content
                }
            case .trailing:
                HStack {
                    content
                    _YAxisTitle_View(chartData: chartData, text: text, style: style)
                }
            }
        }
    }
}

// MARK: - Extension
extension View {
    public func axisTitle<ChartData>(
        chartData: ChartData,
        text: String,
        style: AxisTitleData
    ) -> some View
    where ChartData: CTChartData & ViewDataProtocol
    {
        self.modifier(AxisTitle(chartData: chartData, text: text, style: style))
    }
}

// MARK: - X View
fileprivate struct _XAxisTitle_View<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var text: String
    var style: AxisTitleData
    
    internal init(
        chartData: ChartData,
        text: String,
        style: AxisTitleData
    ) {
        self.chartData = chartData
        self.text = text
        self.style = style
    }
    
    var body: some View {
        Text(LocalizedStringKey(text))
            .font(style.font)
            .foregroundColor(style.colour)
            .modifier(_XAxisTitle_Padding(position: style.position))
            .background(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .onAppear {
                            chartData.xAxisViewData.xAxisTitleHeight = geo.size.height + 10
                        }
                }
            )
    }
}

// MARK: - Y View
fileprivate struct _YAxisTitle_View<ChartData>: View where ChartData: CTChartData & YAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var text: String
    var style: AxisTitleData
    
    internal init(
        chartData: ChartData,
        text: String,
        style: AxisTitleData
    ) {
        self.chartData = chartData
        self.text = text
        self.style = style
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text(LocalizedStringKey(text))
                    .font(style.font)
                    .foregroundColor(style.colour)
                    .background(
                        GeometryReader { geo in
                            Rectangle()
                                .foregroundColor(Color.clear)
                                .onAppear {
                                    chartData.yAxisViewData.yAxisTitleWidth = geo.size.height + 10 // 10 to add padding
                                    chartData.yAxisViewData.yAxisTitleHeight = geo.size.width
                                }
                        }
                    )
                    .rotationEffect(Angle.init(degrees: -90), anchor: .center)
                    .fixedSize()
                    .frame(width: chartData.yAxisViewData.yAxisTitleWidth)
//                    .offset(x: 0, y: chartData.yAxisViewData.yAxisTitleHeight / 2)
            }
        }
    }
}


// MARK: - Padding
fileprivate struct _XAxisTitle_Padding: ViewModifier {
    
    private let verticalPadding: CGFloat = 2.0
    private let horizontalPadding: CGFloat = 2.0
    
    var position: Edge
    
    func body(content: Content) -> some View {
        switch position {
        case .top:
            content
                .padding(.bottom, verticalPadding)
        case .bottom:
            content
                .padding(.top, horizontalPadding)
        default:
            content
        }
    }
}
