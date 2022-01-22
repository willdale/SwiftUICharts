//
//  ChartSizeUpdating.swift
//  
//
//  Created by Will Dale on 09/01/2022.
//

import SwiftUI

internal struct ChartSizeUpdating<ChartData>: ViewModifier where ChartData: CTChartData {
    
    private(set) var stateObject: TestStateObject
    private(set) var chartData: ChartData
    
    internal func body(content: Content) -> some View {
        content.background(sizeView)
    }
    
    private var sizeView: some View {
        GeometryReader { geo in
            Color.clear
                .onAppear {
                    chartData.chartSize = geo.frame(in: .local)
                    stateObject.chartSize = geo.frame(in: .local)
                }
                .onChange(of: geo.frame(in: .local)) {
                    chartData.chartSize = $0
                    stateObject.chartSize = $0
                }
        }
    }
}
