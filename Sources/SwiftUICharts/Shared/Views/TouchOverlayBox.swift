//
//  TouchOverlayBox.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
View that displays information from the touch events.
 */
internal struct TouchOverlayBox<T: CTChartData>: View {
    
    @ObservedObject var chartData: T
    
    @Binding private var boxFrame:  CGRect
    
    internal init(chartData: T,
                  boxFrame : Binding<CGRect>
    ) {
        self.chartData = chartData
        self._boxFrame = boxFrame
    }
    
    internal var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
                
                chartData.infoDescription(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                
                chartData.infoValueUnit(info: point)
                    .font(.title3)
                    .foregroundColor(chartData.chartStyle.infoBoxValueColour)

                chartData.infoLegend(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
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
