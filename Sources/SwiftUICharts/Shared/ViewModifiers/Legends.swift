//
//  Legends.swift
//  LineChart
//
//  Created by Will Dale on 02/01/2021.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct Legends<T>: ViewModifier where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private let columns: [GridItem]
    private let width: CGFloat
    private let font: Font
    private let textColor: Color
    private let topPadding: CGFloat
    
    internal init(
        chartData: T,
        columns: [GridItem],
        width: CGFloat,
        font: Font,
        textColor: Color,
        topPadding: CGFloat
    ) {
        self.chartData = chartData
        self.columns = columns
        self.width = width
        self.font = font
        self.textColor = textColor
        self.topPadding = topPadding
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                VStack {
                    content
                    LegendView(chartData: chartData,
                               columns: columns,
                               width: width,
                               font: font,
                               textColor: textColor)
                        .padding(.top, topPadding)
                }
            } else { content }
        }
    }
}

@available(iOS, introduced: 13, deprecated: 14, obsoleted: 14)
internal struct LegendsCompatible<T>: ViewModifier where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private let width: CGFloat
    private let font: Font
    private let textColor: Color
    private let topPadding: CGFloat
    
    internal init(
        chartData: T,
        width: CGFloat,
        font: Font,
        textColor: Color,
        topPadding: CGFloat
    ) {
        self.chartData = chartData
        self.width = width
        self.font = font
        self.textColor = textColor
        self.topPadding = topPadding
    }
    
    internal func body(content: Content) -> some View {
        Group {
            if chartData.isGreaterThanTwo() {
                VStack {
                    content
                    VerticalLegendView(chartData: chartData,
                                       width: width,
                                       font: font,
                                       textColor: textColor)
                        .padding(.top, topPadding)
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
    @available(iOS 14.0, *)
    public func legends<T: CTChartData>(
        chartData: T,
        columns: [GridItem] = [GridItem(.flexible())],
        iconWidth: CGFloat = 40,
        font: Font = .caption,
        textColor: Color = Color.primary,
        topPadding: CGFloat = 18
    ) -> some View {
        self.modifier(Legends(chartData: chartData,
                              columns: columns,
                              width: iconWidth,
                              font: font,
                              textColor: textColor,
                              topPadding: topPadding))
    }
    
    @available(iOS, introduced: 13, deprecated: 14, obsoleted: 14)
    public func legendsCompatible<T: CTChartData>(
        chartData: T,
        iconWidth: CGFloat = 40,
        font: Font = .caption,
        textColor: Color = Color.primary,
        topPadding: CGFloat = 18
    ) -> some View {
        self.modifier(LegendsCompatible(chartData: chartData,
                                        width: iconWidth,
                                        font: font,
                                        textColor: textColor,
                                        topPadding: topPadding))
    }
}
