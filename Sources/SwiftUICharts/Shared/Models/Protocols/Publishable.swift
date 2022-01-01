//
//  PublishableProtocol.swift
//  
//
//  Created by Will Dale on 05/06/2021.
//

import Combine
import SwiftUI

/**
 Protocol to enable publishing data streams over the Combine framework
 */
public protocol Publishable {
    
    associatedtype DataPoint: CTDataPointBaseProtocol
    
    /**
     Streams the data points from touch overlay.
     
     Uses Combine
     */
    var touchedDataPointPublisher: PassthroughSubject<[PublishedTouchData<Self.DataPoint>], Never> { get }
    
    var touchPointData: [DataPoint] { get set }
}

extension Publishable {
    internal func markerSubView(
        markerData: MarkerData,
        touchLocation: CGPoint,
        chartSize: CGRect
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
