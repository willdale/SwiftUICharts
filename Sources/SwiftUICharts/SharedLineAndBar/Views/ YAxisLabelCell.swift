//
//   YAxisLabelCell.swift
//  
//
//  Created by Will Dale on 26/03/2021.
//

import SwiftUI

internal struct XAxisDataPointCell<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let rotationAngle: Angle
    
    internal init(
        chartData: ChartData,
        label: String,
        rotationAngle: Angle
    ) {
        self.chartData = chartData
        self.label = label
        self.rotationAngle = rotationAngle
    }
    
    @State private var width: CGFloat = 0
    
    internal var body: some View {
        Text(label)
            .font(chartData.chartStyle.xAxisLabelFont)
            .lineLimit(1)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.width = geo.frame(in: .local).width
                        }
                }
            )
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotationAngle, anchor: .center)
            .frame(width: 10, height: width)
            .onAppear {
                chartData.viewData.xAxisLabelHeights.append(width)
            }
    }
}

internal struct XAxisChartDataCell<ChartData>: View where ChartData: CTLineBarChartDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let label: String
    private let rotationAngle: Angle
    
    internal init(
        chartData: ChartData,
        label: String,
        rotationAngle: Angle
    ) {
        self.chartData = chartData
        self.label = label
        self.rotationAngle = rotationAngle
    }
    
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    
    internal var body: some View {
        Text(label)
            .font(chartData.chartStyle.xAxisLabelFont)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
            .rotationEffect(rotationAngle, anchor: .center)
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            self.width = geo.frame(in: .local).width
                            self.height = geo.frame(in: .local).height
                        }
                }
            )
            .frame(width: rotationDegrees || rotationRadians ? 10 : width,
                   height: rotationAngle == .init(degrees: 0) || rotationAngle == .init(radians: 0) ? height : width)
            .onAppear {
                chartData.viewData.xAxisLabelHeights.append(width)
            }
    }
    
    private var rotationDegrees: Bool {
        rotationAngle == .init(degrees: 90) || rotationAngle == .init(degrees: -90)
    }
    private var rotationRadians: Bool {
        rotationAngle == .init(radians: 1.5708) || rotationAngle == .init(radians: -1.5708)
    }
}
