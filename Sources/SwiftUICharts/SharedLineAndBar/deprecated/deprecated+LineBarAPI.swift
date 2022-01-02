//
//  deprecated+LineBarAPI.swift
//  
//
//  Created by Will Dale on 30/10/2021.
//

import SwiftUI

extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     Places the info box on top of the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to display touch overlay information.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public func floatingInfoBox<ChartData>(chartData: ChartData) -> some View
    where ChartData: CTLineBarChartDataProtocol & Publishable {
        EmptyView()
    }
    
    /**
     A view that displays information from `TouchOverlay`.
     
     Places the info box on top of the chart.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to display touch overlay information.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public func floatingInfoBox<ChartData>(chartData: ChartData) -> some View
    where ChartData: CTLineBarChartDataProtocol & HorizontalChart & Publishable {
        EmptyView()
    }
}

extension View {
    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameter chartData: Chart data model.
     - Returns: A  new view containing the chart with a view to display touch overlay information.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public func infoBox<ChartData>(
        chartData: ChartData,
        height: CGFloat = 70
    ) -> some View
    where ChartData: CTLineBarChartDataProtocol & Publishable {
        EmptyView()
    }

    /**
     A view that displays information from `TouchOverlay`.
     
     - Parameters:
        - chartData: Chart data model.
        - width: Width of the view.
     - Returns: A  new view containing the chart with a view to display touch overlay information.
     */
    @available(*, deprecated, message: "Please use \"infoDisplay\" instead.")
    public func infoBox<ChartData>(
        chartData: ChartData,
        width: CGFloat = 70
    ) -> some View
    where ChartData: CTLineBarChartDataProtocol & HorizontalChart & Publishable {
        EmptyView()
    }
}

extension View {
    /**
     Draws a line across the chart to show the the trend in the data.
     
     - Parameters:
        - chartData: Chart data model.
        - firstValue: The value of the leading data point.
        - lastValue: The value of the trailnig data point.
        - lineColour: Line Colour.
        - strokeStyle: Stroke Style.
     - Returns: A  new view containing the chart with a trend line.
     */
    @available(*, deprecated, message: "Please use `.extraLine` instead.")
    public func linearTrendLine<T: CTLineBarChartDataProtocol & GetDataProtocol>(
        chartData: T,
        firstValue: Double,
        lastValue: Double,
        lineColour: ColourStyle = ColourStyle(),
        strokeStyle: StrokeStyle = StrokeStyle()
    ) -> some View {
        EmptyView()
    }
}

