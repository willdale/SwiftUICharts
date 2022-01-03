//
//  XAxisLabels.swift
//  LineChart
//
//  Created by Will Dale on 26/12/2020.
//

import SwiftUI

public struct XAxisLabelStyle {
    var position: XAxisLabelPosistion
    var font: Font
    var fontColour: Color
    var dataFrom: LabelsFrom
}

extension XAxisLabelStyle {
    public static let standard = XAxisLabelStyle(position: .bottom,
                                                 font: .caption,
                                                 fontColour: .primary,
                                                 dataFrom: .dataPoint(rotation: .degrees(0)))
}

internal struct XAxisLabels<ChartData>: ViewModifier where ChartData: CTChartData & AxisX & ViewDataProtocol {
    
    @ObservedObject private var chartData: ChartData
    private var style: XAxisLabelStyle
    
    internal init(
        chartData: ChartData,
        style: XAxisLabelStyle
    ) {
        self.chartData = chartData
        self.style = style
        
        self.chartData.xAxisViewData.hasXAxisLabels = true
    }
    
    internal func body(content: Content) -> some View {
        Group {
            switch style.position {
            case .bottom:
                VStack {
                    content
                    chartData.getXAxisLabels()
                        .padding(.top, 2)
                }
            case .top:
                VStack {
                    chartData.getXAxisLabels()
                        .padding(.bottom, 2)
                    content
                }
            }
        }
    }
}

extension View {
    /// Labels for the X axis.
    ///
    /// Verbose method
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        position: XAxisLabelPosistion,
        font: Font,
        fontColour: Color,
        dataFrom: LabelsFrom
    ) -> some View
    where ChartData: CTChartData & ChartAxes & ViewDataProtocol
    {
        self.modifier(
            XAxisLabels(
                chartData: chartData,
                style: XAxisLabelStyle(position: position, font: font, fontColour: fontColour, dataFrom: dataFrom)
            )
        )
    }
    
    /// Labels for the X axis.
    ///
    /// Convenience method
    public func xAxisLabels<ChartData>(
        chartData: ChartData,
        style: XAxisLabelStyle = .standard
    ) -> some View
    where ChartData: CTChartData & ChartAxes & ViewDataProtocol
    {
        self.modifier(
            XAxisLabels(
                chartData: chartData,
                style: style
            )
        )
    }
}
