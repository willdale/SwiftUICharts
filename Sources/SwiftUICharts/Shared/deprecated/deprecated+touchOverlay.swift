//
//  deprecated+touchOverlay.swift
//  
//
//  Created by Will Dale on 03/04/2022.
//

import SwiftUI

extension View {
    
    /**
     Adds touch interaction with the chart.
     
     Adds an overlay to detect touch and display the relivent information from the nearest data point.
     
     - Attention:
     Unavailable in tvOS
     */
    @available(*, deprecated, message: "Please use \".touch\" instead")
    public func touchOverlay<ChartData: CTChartData & Touchable>(
        chartData: ChartData,
        specifier: String = "%.0f",
        unit: TouchUnit = .none,
        minDistance: CGFloat = 0
    ) -> some View {
        #if !os(tvOS)
        self.modifier(EmptyModifier())
        #elseif os(tvOS)
        self.modifier(EmptyModifier())
        #endif
    }
}
