//
//  AxisMarkerStyle.swift
//  
//
//  Created by Will Dale on 13/03/2022.
//

import SwiftUI

public struct AxisMarkerStyle {
    public var colour: Color
    public var strokeStyle: StrokeStyle
    
    public enum Horizontal {
        case leading
        case trailing
        case center
    }
    
    public enum Vertical {
        case top
        case bottom
        case center
    }
}

extension AxisMarkerStyle {
    public static let amber = AxisMarkerStyle(colour: Color(red: 1.0, green: 0.75, blue: 0.25),
                                              strokeStyle: StrokeStyle(lineWidth: 1, dash: [5,10]))
}
