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

extension Gradient.Stop {
    internal init(_ gradientStop: GradientStop) {
        self.init(color: gradientStop.color,
                  location: gradientStop.location)
    }
}
