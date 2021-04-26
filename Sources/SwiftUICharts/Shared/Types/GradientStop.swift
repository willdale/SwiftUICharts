//
//  GradientStop.swift
//  LineChart
//
//  Created by Will Dale on 09/01/2021.
//

import SwiftUI

/**
 A mediator for `Gradient.Stop` to allow it to be stored in `LegendData`.
 
 Gradient.Stop doesn't conform to Hashable.
 */
public struct GradientStop: Hashable {
    
    public var color: Color
    public var location: CGFloat
    
    public init(
        color: Color,
        location: CGFloat
    ) {
        self.color = color
        self.location = location
    }
}

extension GradientStop {
    /// Convert an array of GradientStop into and array of Gradient.Stop
    /// - Parameter stops: Array of GradientStop
    /// - Returns: Array of Gradient.Stop
    static func convertToGradientStopsArray(stops: [GradientStop]) -> [Gradient.Stop] {
        stops.map { Gradient.Stop(color: $0.color, location: $0.location) }
    }
}
