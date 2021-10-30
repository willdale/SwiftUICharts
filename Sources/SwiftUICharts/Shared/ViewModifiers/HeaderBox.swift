//
//  HeaderBox.swift
//  LineChart
//
//  Created by Will Dale on 03/01/2021.
//

import SwiftUI

internal struct HeaderBox<T>: ViewModifier where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private var title: HeaderBoxText?
    private var subtitle: HeaderBoxText?
            
    init(chartData: T,
         title: HeaderBoxText?,
         subtitle: HeaderBoxText?
    ) {
        self.chartData = chartData
        self.title = title
        self.subtitle = subtitle
    }
    
    var titleBox: some View {
        VStack(alignment: .leading) {
            Text(LocalizedStringKey(title?.text ?? ""))
                .font(title?.font)
                .foregroundColor(title?.colour)
            Text(LocalizedStringKey(subtitle?.text ?? ""))
                .font(subtitle?.font)
                .foregroundColor(subtitle?.colour)
        }
    }
    
    internal func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            titleBox
            content
        }
    }
}

extension View {
    /**
     Displays the metadata about the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view above
     to display metadata.
     */
    @available(*, deprecated, message: "Please use the other function instead.")
    public func headerBox<T:CTChartData & Publishable>(chartData: T) -> some View {
        self.modifier(HeaderBox(chartData: chartData,
                                title: HeaderBoxText(text: ""),
                                subtitle: HeaderBoxText(text: "")))
    }
    
    public func titleBox<T:CTChartData & Publishable>(
        chartData: T,
        title: HeaderBoxText? = nil,
        subtitle: HeaderBoxText? = nil
    ) -> some View {
        self.modifier(HeaderBox(chartData: chartData, title: title, subtitle: subtitle))
    }
}

public struct HeaderBoxText {
    public var text: String
    /// Font of the title
    public var font: Font
    /// Color of the title
    public var colour: Color
    
    public init(
        text: String,
        font: Font = .title3,
        colour: Color = Color.primary
    ) {
        self.text = text
        self.font = font
        self.colour = colour
    }
}
