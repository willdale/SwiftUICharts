//
//  Shape+Fill.swift
//  
//
//  Created by Will Dale on 06/11/2021.
//

import SwiftUI

extension Shape {
    func fill(_ color: ChartColour) -> some View {
        Group {
            switch color {
            case .colour(let colour):
                self.fill(colour)
            case .gradient(let colours, let startPoint, let endPoint):
                self.fill(LinearGradient(gradient: Gradient(colors: colours),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
            case .gradientStops(let stops, let startPoint, let endPoint):
                self.fill(LinearGradient(gradient: Gradient(stops: GradientStop.convertToGradientStopsArray(stops: stops)),
                                         startPoint: startPoint,
                                         endPoint: endPoint))
            }
        }
    }
}
