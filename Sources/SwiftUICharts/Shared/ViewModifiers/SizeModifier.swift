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
                .onChange(of: geo.frame(in: .local)) { chartData.chartSize = $0 }
                .onChange(of: geo.frame(in: .global)) { print($0.origin) }
        }
    }
}
