//
//  RotatedText.swift
//  
//
//  Created by Will Dale on 03/05/2021.
//

import SwiftUI

/**
 A view that displays text with rotation.
 
 Each time if gets layed out, it appends it's width
 to `xAxisLabelHeights`  in `viewData`.
 It also sets `xAxislabelWidth` in
 `viewData` of it's approximate width.
 This gets used higher up the view hierarchy
 to set the frame of the of the text after rotation.
 */
internal struct RotatedText<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let rotation: Angle
    
    /**
     Initialises a new instance of RotatedText.
     
     A view that displays text with rotation.
     
     - Parameters:
        - chartData: Chart Data must conform to `CTLineBarChartDataProtocol`.
        - label: The string to show in the `Text` view.
        - rotation: The angle to rotate the `Text` view by.
     */
    internal init(
        chartData: ChartData,
        label: String,
        rotation: Angle
    ) {
        self.chartData = chartData
        self.label = label
        self.rotation = rotation
    }
    
    @State private var finalFrame: CGRect = .zero
    
    internal var body: some View {
        Text(LocalizedStringKey(label))
            .font(chartData.chartStyle.xAxisLabelFont)
            .foregroundColor(chartData.chartStyle.xAxisLabelColour)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            finalFrame = geo.frame(in: .local)
                            if rotation == .degrees(0) || rotation == .radians(0) {
                                chartData.viewData.xAxisLabelHeights.append(geo.frame(in: .local).height)
                                chartData.viewData.xAxislabelWidths.append(geo.frame(in: .local).width)
                            } else {
                                chartData.viewData.xAxisLabelHeights.append(geo.frame(in: .local).width)
                                chartData.viewData.xAxislabelWidths.append(geo.frame(in: .local).height)
                            }
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotation, anchor: .center)
            .frame(width: rotation == .degrees(0) || rotation == .radians(0) ? finalFrame.width : finalFrame.height,
                   height: rotation == .degrees(0) || rotation == .radians(0) ? finalFrame.height : finalFrame.width)
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}



/**
 A view that displays text with rotation.
 
 Each time if gets layed out, it appends it's width
 to `xAxisLabelHeights`  in `viewData`.
 It also sets `xAxislabelWidth` in
 `viewData` of it's approximate width.
 This gets used higher up the view hierarchy
 to set the frame of the of the text after rotation.
 */
internal struct HorizontalRotatedText<ChartData>: View where ChartData: CTLineBarChartDataProtocol & isHorizontal {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    
    /**
     Initialises a new instance of RotatedText.
     
     A view that displays text with rotation.
     
     - Parameters:
        - chartData: Chart Data must conform to `CTLineBarChartDataProtocol`.
        - label: The string to show in the `Text` view.
     */
    internal init(
        chartData: ChartData,
        label: String
    ) {
        self.chartData = chartData
        self.label = label
    }
    
    @State private var finalFrame: CGRect = .zero
    
    internal var body: some View {
        Text(LocalizedStringKey(label))
            .font(chartData.chartStyle.xAxisLabelFont)
            .lineLimit(1)
            .foregroundColor(chartData.chartStyle.xAxisLabelColour)
            .overlay(
                GeometryReader { geo in
                    Rectangle()
                        .foregroundColor(Color.clear)
                        .onAppear {
                            chartData.viewData.yAxisLabelWidth.append(geo.frame(in: .local).width + 10)
                        }
                }
            )
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}




internal struct TempText<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let rotation: Angle
    
    /**
     Initialises a new instance of RotatedText.
     
     A view that displays text with rotation.
     
     - Parameters:
        - chartData: Chart Data must conform to `CTLineBarChartDataProtocol`.
        - label: The string to show in the `Text` view.
        - rotation: The angle to rotate the `Text` view by.
     */
    internal init(
        chartData: ChartData,
        label: String,
        rotation: Angle
    ) {
        self.chartData = chartData
        self.label = label
        self.rotation = rotation
    }
    
    @State private var finalFrame: CGRect = .zero
    
    internal var body: some View {
        Text(LocalizedStringKey(label))
            .font(chartData.chartStyle.xAxisLabelFont)
            .foregroundColor(chartData.chartStyle.xAxisLabelColour)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            if rotation == .degrees(0) {
                                chartData.viewData.xAxisLabelHeights.append(geo.frame(in: .local).height)
                            } else {
                                chartData.viewData.xAxisLabelHeights.append(geo.frame(in: .local).width)
                            }
                            
                            if rotation == .degrees(0) || rotation == .radians(0) {
                                chartData.viewData.xAxislabelWidths.append(geo.frame(in: .local).width)
                            } else {
                                chartData.viewData.xAxislabelWidths.append(geo.frame(in: .local).height)
                            }
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotation, anchor: .center)
            
            .frame(width: rotation == .degrees(0) || rotation == .radians(0) ? finalFrame.width : finalFrame.height,
                   height: rotation == .degrees(0) || rotation == .radians(0) ? finalFrame.height : finalFrame.width)
            .accessibilityLabel(LocalizedStringKey("X-Axis-Label"))
            .accessibilityValue(LocalizedStringKey(label))
    }
}
