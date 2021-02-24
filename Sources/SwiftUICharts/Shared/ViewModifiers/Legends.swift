//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

/**
 Displays legends under the chart.
 */
internal struct Legends<T>: ViewModifier where T: CTChartData {
    
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
        Group {
            if chartData.isGreaterThanTwo() {
                VStack {
                    content
                    LegendView(chartData: chartData, columns: columns, textColor: textColor)
                }
            } else { content }
        }
    }
}
    
extension View {
    /**
     Displays legends under the chart.
     
     - Parameters:
        - chartData: Chart data model.
        - columns: How to layout the legends.
        - textColor: Colour of the text.
     - Returns: A  new view containing the chart with chart legends under.
     */
    public func legends<T:CTChartData>(chartData: T, columns: [GridItem] = [GridItem(.flexible())], textColor: Color = Color.primary) -> some View {
        self.modifier(Legends(chartData: chartData, columns: columns, textColor: textColor))
    }
}

