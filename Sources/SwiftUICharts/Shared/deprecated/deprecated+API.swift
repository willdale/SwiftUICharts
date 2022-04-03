//
//  File.swift
//  
//
//  Created by Will Dale on 02/08/2021.
//

import SwiftUI

/**
 Displays the data points value with the unit.
 */
@available(*, deprecated, message: "Please use `touchedDataPointPublisher` in chart data model.")
public struct InfoValue<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoValueUnit(info: point)
        }
    }
}

/**
 Displays the data points description.
 */
@available(*, deprecated, message: "Please use `touchedDataPointPublisher` in chart data model.")
public struct InfoDescription<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    
    public init(chartData: T) {
        self.chartData = chartData
    }
    
    public var body: some View {
        ForEach(chartData.infoView.touchOverlayInfo, id: \.id) { point in
            chartData.infoDescription(info: point)
        }
    }
}

/**
 Option to display a string between the Value and the Description.
 */
@available(*, deprecated, message: "Please use `touchedDataPointPublisher` in chart data model.")
public struct InfoExtra<T>: View where T: CTChartData {
    
    @ObservedObject private var chartData: T
    private let text: String
    
    public init(chartData: T, text: String) {
        self.chartData = chartData
        self.text = text
    }
    
    public var body: some View {
        if chartData.infoView.isTouchCurrent {
            Text(text)
        } else {
            EmptyView()
        }
    }
}

@available(*, deprecated, message: "")
extension LegendData {
    /**
     Get the legend as a view.
     
     - Parameter textColor: Colour of the text
     - Returns: The relevent legend as a view.
     */
    @available(*, deprecated, message: "")
    public func getLegend(
        width: CGFloat = 40,
        font: Font = .caption,
        textColor: Color = .primary
    ) -> some View {
        EmptyView()
    }
    /**
     Get the legend as a view where the colour is indicated by a Circle.
     
     - Parameter textColor: Colour of the text
     - Returns: The relevent legend as a view.
     */
    @available(*, deprecated, message: "")
    public func getLegendAsCircle(
        width: CGFloat = 12,
        font: Font = .caption,
        textColor: Color
    ) -> some View {
        EmptyView()
    }
}
