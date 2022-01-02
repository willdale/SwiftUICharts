//
//  AxisCharts.swift
//  
//
//  Created by Will Dale on 02/01/2022.
//

import SwiftUI

public protocol AxisCharts {}

extension AxisCharts where Self: BarChartType {
    internal func markerSubView(
        markerData: MarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint
    ) -> some View {
        ZStack {
            ForEach(markerData.barMarkerData, id: \.self) { marker in
                MarkerView.bar(barMarker: marker.markerType, markerData: marker)
            }
            
            ForEach(markerData.lineMarkerData, id: \.self) { marker in
                MarkerView.line(lineMarker: marker.markerType,
                                markerData: marker,
                                chartSize: chartSize,
                                touchLocation: touchLocation,
                                dataPoints: marker.dataPoints,
                                lineType: marker.lineType,
                                lineSpacing: marker.lineSpacing,
                                minValue: marker.minValue,
                                range: marker.range)
            }
        }
    }
}

extension AxisCharts where Self: LineChartType {
    internal func markerSubView(
        markerData: MarkerData,
        chartSize: CGRect,
        touchLocation: CGPoint
    ) -> some View {
        ForEach(markerData.lineMarkerData, id: \.self) { marker in
            MarkerView.line(lineMarker: marker.markerType,
                            markerData: marker,
                            chartSize: chartSize,
                            touchLocation: touchLocation,
                            dataPoints: marker.dataPoints,
                            lineType: marker.lineType,
                            lineSpacing: marker.lineSpacing,
                            minValue: marker.minValue,
                            range: marker.range)
        }
    }
}
