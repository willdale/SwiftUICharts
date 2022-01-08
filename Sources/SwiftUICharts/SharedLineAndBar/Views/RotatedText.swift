//
//  RotatedText.swift
//  
//
//  Created by Will Dale on 03/05/2021.
//

import SwiftUI

internal struct RotatedText<ChartData>: View where ChartData: CTChartData & XAxisViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let position: LabelPositionable
    private var style: XAxisLabelStyle
    
    /**
     Initialises a new instance of RotatedText.
     
     A view that displays text with rotation.
     
     - Parameters:
     */
    internal init(
        chartData: ChartData,
        label: String,
        position: LabelPositionable,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.label = label
        self.position = position
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
                            switch position.type {
                            case.vertical:
                                finalFrame = geo.frame(in: .local)
                                chartData.xAxisViewData.xAxisLabelHeights.append(geo.frame(in: .local).width)
                                if style.rotation == .degrees(0) || style.rotation == .radians(0) {
                                    chartData.xAxisViewData.xAxisLabelWidths.append(geo.frame(in: .local).width)
                                } else {
                                    chartData.xAxisViewData.xAxisLabelWidths.append(geo.frame(in: .local).height)
                                }
                            case .horizontal:
                                chartData.xAxisViewData.xAxisLabelWidths.append(geo.frame(in: .local).width + 10)
                            default:
                                break
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
