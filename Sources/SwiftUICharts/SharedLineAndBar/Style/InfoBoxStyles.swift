//
//  InfoBoxStyles.swift
//  
//
//  Created by Will Dale on 02/10/2021.
//

import SwiftUI

// MARK: - Vertical Info Box
internal struct VerticalInfoBoxViewModifier<ChartData, S: Shape>: ViewModifier
where ChartData: CTLineBarChartDataProtocol & InfoData {
    
    @ObservedObject private var chartData: ChartData
    private var style: InfoBoxStyle
    private var shape: S
    
    @State private var boxFrame: CGRect = .zero
    
    internal init(
        chartData: ChartData,
        style: InfoBoxStyle,
        shape: S
    ) {
        self.chartData = chartData
        self.style = style
        self.shape = shape
    }
    
    internal func body(content: Content) -> some View {
        content
            .infoDisplay(chartData: chartData,
                          infoView: VerticalInfoBoxView(chartData: chartData,
                                                        style: style,
                                                        shape: shape,
                                                        boxFrame: $boxFrame)) {
                setBoxLocation($0, $1)
            }
    }
    
    private func setBoxLocation(_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint {
        if chartData is isHorizontal {
            return CGPoint(x: 35,
                           y: chartData.setBoxLocation(touchLocation: chartData.infoView.touchLocation.y,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartData.infoView.chartSize))
        } else {
            return CGPoint(x: chartData.setBoxLocation(touchLocation: touchLocation.x,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartSize),
                           y: boxFrame.midY)
        }
    }
}


internal struct VerticalInfoBoxView<ChartData, S: Shape>: InfoDisplayable
where ChartData: InfoData {

    @ObservedObject internal var chartData: ChartData
    private var style: InfoBoxStyle
    private var shape: S
    
    @Binding private var boxFrame: CGRect
    
    internal init(
        chartData: ChartData,
        style: InfoBoxStyle,
        shape: S,
        boxFrame: Binding<CGRect>
    ) {
        self.chartData = chartData
        self.style = style
        self.shape = shape
        self._boxFrame = boxFrame
    }
    
    internal var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(chartData.touchPointData, id: \.id) { point in
                chartData.infoDescription(info: point)
                    .font(style.descriptionFont)
                    .foregroundColor(style.descriptionColour)
                chartData.infoValueUnit(info: point)
                    .font(style.valueFont)
                    .foregroundColor(style.valueColour)
                chartData.infoLegend(info: point)
                    .foregroundColor(style.descriptionColour)
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    shape
                        .fill(style.backgroundColour)
                        .overlay(
                            shape
                                .stroke(style.borderColour, style: style.borderStyle)
                        )
                        .onAppear {
                            self.boxFrame = geo.frame(in: .local)
                        }
                        .onChange(of: geo.frame(in: .local)) { frame in
                            self.boxFrame = frame
                        }
                }
            }
        )
    }
}

// MARK: - Horizontal Info Box
internal struct HorizontalInfoBoxViewModifier<ChartData, S: Shape>: ViewModifier
where ChartData: CTLineBarChartDataProtocol & InfoData {
    
    @ObservedObject private var chartData: ChartData
    private var style: InfoBoxStyle
    private var shape: S
    
    @State private var boxFrame: CGRect = .zero
    
    internal init(
        chartData: ChartData,
        style: InfoBoxStyle,
        shape: S
    ) {
        self.chartData = chartData
        self.style = style
        self.shape = shape
    }
    
    internal func body(content: Content) -> some View {
        content
            .infoDisplay(chartData: chartData,
                          infoView: HorizontalInfoBoxView(chartData: chartData,
                                                          style: style,
                                                          shape: shape,
                                                          boxFrame: $boxFrame)) {
                setBoxLocation($0, $1)
            }
    }
    
    private func setBoxLocation(_ touchLocation: CGPoint, _ chartSize: CGRect) -> CGPoint {
        if chartData is isHorizontal {
            return CGPoint(x: chartData.setBoxLocation(touchLocation: touchLocation.x,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartSize),
                           y: boxFrame.midY - 10)
        } else {
            return CGPoint(x: chartData.setBoxLocation(touchLocation: touchLocation.y,
                                                       boxFrame: boxFrame,
                                                       chartSize: chartSize),
                           y: 35)
        }
    }
}


internal struct HorizontalInfoBoxView<ChartData, S: Shape>: InfoDisplayable
where ChartData: InfoData {

    @ObservedObject internal var chartData: ChartData
    private var style: InfoBoxStyle
    private var shape: S
    
    @Binding private var boxFrame: CGRect
    
    internal init(
        chartData: ChartData,
        style: InfoBoxStyle,
        shape: S,
        boxFrame: Binding<CGRect>
    ) {
        self.chartData = chartData
        self.style = style
        self.shape = shape
        self._boxFrame = boxFrame
    }
    
    internal var content: some View {
        HStack {
            ForEach(chartData.touchPointData, id: \.id) { point in
                chartData.infoLegend(info: point)
                    .foregroundColor(style.descriptionColour)
                    .layoutPriority(1)
                chartData.infoDescription(info: point)
                    .font(style.descriptionFont)
                    .foregroundColor(style.descriptionColour)
                chartData.infoValueUnit(info: point)
                    .font(style.valueFont)
                    .foregroundColor(style.valueColour)
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    shape
                        .fill(style.backgroundColour)
                        .overlay(
                            shape
                                .stroke(style.borderColour, style: style.borderStyle)
                        )
                        .onChange(of: geo.frame(in: .local)) { frame in
                            self.boxFrame = frame
                        }
                }
            }
        )
    }
}
