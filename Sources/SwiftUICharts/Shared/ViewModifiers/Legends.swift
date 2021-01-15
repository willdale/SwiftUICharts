//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct Legends: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    internal func body(content: Content) -> some View {
        VStack {
            content
            LegendView(chartData: chartData)
        }
    }
}
extension View {
    /// Displays legends under the chart.
    /// - Returns: Legends from the charts data and any markers.
    public func legends() -> some View {
        self.modifier(Legends())
    }
}
