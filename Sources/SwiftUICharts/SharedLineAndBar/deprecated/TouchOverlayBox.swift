//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
 View that displays information from the touch events.
 
 Deprecated -  Use `InfoDisplay` instead
 */
internal struct TouchOverlayBox<ChartData>: View where ChartData: CTChartData & Publishable {
    
    @ObservedObject private var chartData: ChartData
    
    @Binding private var boxFrame: CGRect
    
    internal init(
        chartData: ChartData,
        boxFrame: Binding<CGRect>
    ) {
        self.chartData = chartData
        self._boxFrame = boxFrame
    }
    
    internal var body: some View {
        Group {
            if chartData.chartStyle.infoBoxContentAlignment == .vertical {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(chartData.touchPointData, id: \.id) { point in
                        chartData.infoDescription(info: point)
                            .font(chartData.chartStyle.infoBoxDescriptionFont)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                        chartData.infoValueUnit(info: point)
                            .font(chartData.chartStyle.infoBoxValueFont)
                            .foregroundColor(chartData.chartStyle.infoBoxValueColour)
                        chartData.infoLegend(info: point)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                    }
                }
            } else {
                HStack {
                    ForEach(chartData.touchPointData, id: \.id) { point in
                        chartData.infoLegend(info: point)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                            .layoutPriority(1)
                        chartData.infoDescription(info: point)
                            .font(chartData.chartStyle.infoBoxDescriptionFont)
                            .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                        chartData.infoValueUnit(info: point)
                            .font(chartData.chartStyle.infoBoxValueFont)
                            .foregroundColor(chartData.chartStyle.infoBoxValueColour)
                    }
                }
            }
        }
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                        .fill(chartData.chartStyle.infoBoxBackgroundColour)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                                .stroke(chartData.chartStyle.infoBoxBorderColour, style: chartData.chartStyle.infoBoxBorderStyle)
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
