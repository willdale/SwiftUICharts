//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

struct Legends: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    func body(content: Content) -> some View {
        VStack {
            content
            LegendView(chartData: chartData)
        }
    }
}
extension View {
    public func legends() -> some View {
        self.modifier(Legends())
    }
}
