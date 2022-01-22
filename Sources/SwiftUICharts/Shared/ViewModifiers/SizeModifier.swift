//
//  SizeModifier.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import SwiftUI

struct SizeModifier<ChartData>: ViewModifier where ChartData: CTChartData {
    
    private var chartData: ChartData
    
    internal init(chartData: ChartData) {
        self.chartData = chartData
    }
    
    func body(content: Content) -> some View {
        content.background(sizeView)
    }
    
    private var sizeView: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    chartData.chartSize = geo.frame(in: .local)
                }

                .onChange(of: geo.frame(in: .local)) {
                    chartData.chartSize = $0
                }
        }
    }
}
