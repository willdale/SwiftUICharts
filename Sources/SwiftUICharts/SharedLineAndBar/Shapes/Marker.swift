//
//  Marker.swift
//  
//
//  Created by Will Dale on 30/12/2020.
//

import SwiftUI

/// Generic line, drawn horizontally across the chart.
internal struct HorizontalMarker<ChartData>: Shape where ChartData: CTChartData & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Double
    
    internal init(
        chartData: ChartData,
        value: Double
    ) {
        self.chartData = chartData
        self.value = value
    }
    
    internal func path(in rect: CGRect) -> Path {
        
        let pointY: CGFloat = chartData.yAxisPOIMarkerPosition(value: value, position: PoiStyle.HorizontalPosition.center, chartSize: rect.size).y
        
        let firstPoint = CGPoint(x: 0, y: pointY)
        let nextPoint = CGPoint(x: rect.width, y: pointY)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

/// Generic line, drawn vertically across the chart.
internal struct VerticalMarker<ChartData>: Shape where ChartData: CTChartData & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Double
    
    internal init(
        chartData: ChartData,
        value: Double
    ) {
        self.chartData = chartData
        self.value = value
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointX: CGFloat = chartData.yAxisPOIMarkerPosition(value: value, position: PoiStyle.VerticalPosition.center, chartSize: rect.size).x
        
        let firstPoint = CGPoint(x: pointX, y: 0)
        let nextPoint = CGPoint(x: pointX, y: rect.height)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}


/// Generic line, drawn vertically across the chart.
internal struct VerticalAbscissaMarker<ChartData>: Shape where ChartData: CTChartData & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Int
    private let total: Int
    
    internal init(
        chartData: ChartData,
        value: Int,
        total: Int
    ) {
        self.chartData = chartData
        self.value = value
        self.total = total
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointX: CGFloat = chartData.xAxisPOIMarkerPosition(value: value, count: total, position: PoiStyle.VerticalPosition.center, chartSize: rect).x
        let firstPoint = CGPoint(x: pointX, y: 0)
        let nextPoint = CGPoint(x: pointX, y: rect.height)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}

/// Generic line, drawn horizontally across the chart.
internal struct HorizontalAbscissaMarker<ChartData>: Shape where ChartData: CTChartData & PointOfInterestProtocol {
    
    @ObservedObject private var chartData: ChartData
    private let value: Int
    private let total: Int
    
    internal init(
        chartData: ChartData,
        value: Int,
        total: Int
    ) {
        self.chartData = chartData
        self.value = value
        self.total = total
    }
    
    internal func path(in rect: CGRect) -> Path {
        let pointY: CGFloat = chartData.xAxisPOIMarkerPosition(value: value, count: total, position: PoiStyle.HorizontalPosition.center, chartSize: rect).y
        let firstPoint = CGPoint(x: 0, y: pointY)
        let nextPoint = CGPoint(x: rect.width, y: pointY)
        
        var path = Path()
        path.move(to: firstPoint)
        path.addLine(to: nextPoint)
        return path
    }
}
