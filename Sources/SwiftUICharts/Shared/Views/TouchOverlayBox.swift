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
        
        HStack {
            ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
                
                chartData.infoValue(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxValueColour)
                
                chartData.infoDescription(info: point)
                    .font(.subheadline)
                    .foregroundColor(chartData.chartStyle.infoBoxDescriptionColour)
                
            }
        }
        
        .padding(.all, 8)
        .background(
            GeometryReader { geo in
                if chartData.infoView.isTouchCurrent {
                    Group {
                        RoundedRectangle(cornerRadius: 5.0, style: .continuous)
                            .fill(Color.systemsBackground)
                    }
                    .overlay(
                        Group {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.primary, lineWidth: 1)
                        }
                    )
                    .onChange(of: geo.frame(in: .local)) { frame in
                        self.boxFrame = frame
                    }
                }
            }
        )
    }
}
