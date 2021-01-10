//
//  LineChartPoints.swift
//  LineChart
//
//  Created by Will Dale on 24/12/2020.
//

import SwiftUI

internal struct PointMarkers: ViewModifier {
    
    @EnvironmentObject var chartData: ChartData
    
    @ViewBuilder
    internal func body(content: Content) -> some View {
        
        if let pointStyle = chartData.pointStyle {
            ZStack {
                content
                switch pointStyle.pointType {
                case .filled:
                    Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape)
                        .fill(pointStyle.fillColour)
                case .outline:
                    Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape)
                        .stroke(pointStyle.borderColour, lineWidth: pointStyle.lineWidth)
                case .filledOutLine:
                    Point(chartData: chartData, pointSize: pointStyle.pointSize, pointType: pointStyle.pointShape)
                        .stroke(pointStyle.borderColour, lineWidth: pointStyle.lineWidth)
                        .background(Point(chartData: chartData,
                                          pointSize: pointStyle.pointSize,
                                          pointType: pointStyle.pointShape)
                                        .foregroundColor(pointStyle.fillColour)
                        )
                }
            }
        } else {
            EmptyView()
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

/**
 Style of the point marks
 ```
 case filled // Just fill
 case outline // Just stroke
 case filledOutLine // Both fill and stroke
 ```
 */
public enum PointType {
    /// Just fill
    case filled
    /// Just stroke
    case outline
    /// Both fill and stroke
    case filledOutLine
}
/**
 Shape of the points
 ```
 case circle
 case square
 case roundSquare
 ```
 */
public enum PointShape {
    /// Circle Shape
    case circle
    /// Square Shape
    case square
    /// Rounded Square Shape
    case roundSquare
}
