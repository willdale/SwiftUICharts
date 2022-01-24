//
//  ChartColour.swift
//  
//
//  Created by Will Dale on 02/01/2022.
//

import SwiftUI

/// Was ColourStyle
public enum ChartColour: Hashable, Equatable {
    case colour(colour: Color)
    case gradient(colours: [Color], startPoint: UnitPoint, endPoint: UnitPoint)
    case gradientStops(stops: [Gradient.Stop], startPoint: UnitPoint, endPoint: UnitPoint)
}

