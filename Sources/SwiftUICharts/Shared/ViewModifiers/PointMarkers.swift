//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    internal func body(content: Content) -> some View {
        
        let pointStyle = chartData.pointStyle
        
        return ZStack {
            content
            switch pointStyle.pointType {
            case .filled:
                Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape, chartType: chartData.viewData.chartType)
                    .fill(pointStyle.fillColour)
            case .outline:
                Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape, chartType: chartData.viewData.chartType)
                    .stroke(pointStyle.borderColour, lineWidth: pointStyle.lineWidth)
            case .filledOutLine:
                Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape, chartType: chartData.viewData.chartType)
                    .stroke(pointStyle.borderColour, lineWidth: pointStyle.lineWidth)
                    .background(Point(chartData: chartData,
                                      pointSize: pointStyle.pointSize,
                                      pointType: pointStyle.pointShape, chartType: chartData.viewData.chartType)
                                    .foregroundColor(pointStyle.fillColour)
                    )
            }
        }
    }
}
extension View {
    /// Lays out markers over each of the data point.
    ///
    /// The style of the markers is set in the PointStyle data model as parameter in ChartData
    public func pointMarkers() -> some View {
        self.modifier(PointMarkers())
    }
}
