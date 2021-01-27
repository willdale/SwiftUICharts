//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct Legends<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData: T
    
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
    public func legends<T:ChartData>(chartData: T) -> some View {
        self.modifier(Legends(chartData: chartData))
    }
}
