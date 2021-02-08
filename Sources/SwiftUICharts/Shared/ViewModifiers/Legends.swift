//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

internal struct Legends<T>: ViewModifier where T: ChartData {
    
    @ObservedObject var chartData: T
    private let columns     : [GridItem]
    private let textColor   : Color
    
    init(chartData: T,
         columns  : [GridItem],
         textColor: Color
    ) {
        self.chartData = chartData
        self.columns   = columns
        self.textColor = textColor
    }
    
    internal func body(content: Content) -> some View {
        VStack {
            content
            LegendView(chartData: chartData, columns: columns, textColor: textColor)
        }
    }
}
    
extension View {
    /**
     Displays legends under the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with chart legends under.
     
     - Tag: Legends
     */
    public func legends<T:ChartData>(chartData: T, columns: [GridItem] = [GridItem(.flexible())], textColor: Color = Color.primary) -> some View {
        self.modifier(Legends(chartData: chartData, columns: columns, textColor: textColor))
    }
}

